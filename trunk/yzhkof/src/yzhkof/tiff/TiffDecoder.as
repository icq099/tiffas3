package yzhkof.tiff
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import yzhkof.BytesUtil;
	
	public class TiffDecoder
	{
		private var tiff:ByteArray;
		private var info:TiffAnalyser;
		private var image_offset:int;
		private var bitmapData:BitmapData;
		
		public function TiffDecoder(tiff:ByteArray)
		{
			
			this.tiff=tiff;
			info=new TiffAnalyser(tiff);
			init();
			
		}
		private function init():void{
			
			if(info.version==42){
				
				deCode();
			
			}
		
		}
		private function deCode():void{
			
			image_offset=info.stripOffsets;
			
			switch(info.samplesPerPixel){
				
				case 0:
				case 1:
					deCode1C();								
				break;
				case 3:
					deCode3C();								
				break;
				default:
					trace("不支持的格式！");
					return							
				break;
			}
		
		}
		private function deCode3C():void{
			
			bitmapData=new BitmapData(info.width,info.height);
			
			var image_length:int=info.height;
			var lineWidth:int=info.width*3;
			var y:int=0;
			var clr:uint;
			
			tiff.endian=Endian.BIG_ENDIAN;

			for(var j:int = 0; j<image_length; j++) {
				var pos:int = image_offset + lineWidth * j; 
				for( var x:int = 0; x<lineWidth; x+=3) {
					tiff.position=pos+x;
					clr=uint(tiff.readShort())<<8;
					clr+=uint(tiff[pos+x+2]);
					bitmapData.setPixel(x/3,y, clr);
				}
				y++;
			}
			tiff.endian=Endian.LITTLE_ENDIAN;
		
		}
		private function deCode1C():void{			
			
			var image_width:int=info.width;
			var image_height:int=info.height;
			var clr:uint;
			var bit:Array;
			
			bitmapData=new BitmapData(image_width,image_height);
			tiff.position=image_offset;
	
			tiff.endian=Endian.BIG_ENDIAN;
			for(var y:int = 0; y<image_height; y++) {
				
				for(var x:int=0;x<image_width/8;x++){
					
					bit=BytesUtil.bytePerBit(tiff.readByte());
					
					for(var b:int=0;b<8;b++){
						
						clr=bit[b]?0xffffff:0x000000;
						bitmapData.setPixel(x*8+b,y,clr);
						
					}
				}
			
			}
			
			tiff.endian=Endian.LITTLE_ENDIAN;
		
		}
		protected function defaultGrayMap(bitDepth:int):Array
		{
			var palette:Array = new Array();
			var nofc:int = Math.pow(2, bitDepth);
			var clr:uint;
			
			for(var c:int=0; c<3; c++) {				// cycle through channels, R, G, B
				for(var i:int=0; i<nofc; i++)
				{
					switch(bitDepth) {
						case 1:
						if(info.photometricInterpretation == 1) clr = (i*255);
						if(info.photometricInterpretation == 0) clr = 255-(i*255);
						clr += clr << 8;
						break;
						
						case 8:
						clr = i;
						clr += clr << 8;
						break;
					}
					palette.push(clr);
				}
			}
			return palette;
		}
		public function get bitmapdata():BitmapData{
			
			return bitmapData;
		
		}

	}
}
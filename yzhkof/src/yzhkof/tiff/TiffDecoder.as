package yzhkof.tiff
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
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
				
				case 3:
					deCode3C();								
				break;
				default:
					trace("不支持的格式！");								
				break;
			}
		
		}
		private function deCode3C():void{
			
			var image_length:int=info.height;
			var lineWidth:int=info.width*3;
			var y:int=0;
			var clr:uint;
			
			bitmapData=new BitmapData(info.width,image_length,true);
			tiff.endian=Endian.BIG_ENDIAN;

			for(var j:int = 0; j<image_length; j++) {
				var pos:int = image_offset + lineWidth * j; 
				for( var x:int = 0; x<lineWidth; x+=3) {
					tiff.position=pos+x;
					clr=uint(tiff.readShort())<<8
					clr+=uint(tiff[pos+x+2]);
					bitmapData.setPixel(x/3,y, clr);
				}
				y++;
			}
			tiff.endian=Endian.LITTLE_ENDIAN;
		
		}
		public function get bitmapdata():BitmapData{
			
			return bitmapData;
		
		
		}

	}
}
package yzhkof.tiff
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class TiffAnalyser
	{
		private var tiff:ByteArray=new ByteArray();
		private var ifd_offset:int;
		private var _order:String;
		private var _ver:int;
		
		public function TiffAnalyser(tiff:ByteArray)
		{
			this.tiff=tiff;
			tiff.endian=Endian.LITTLE_ENDIAN;
			analizeHead();
		}
		private function analizeHead():void{
			//读取order
			_order=tiff.readMultiByte(2,"utf-8");
			//读取ver
			_ver=tiff.readShort();
			//读取IFD的偏移量
			ifd_offset=tiff.readUnsignedInt();		
			
		}
		public function getIFDContextByTag(tag:int):*{
			
			for(var i:int=0;i<IFDNum;i++){
				
				if(getIFDtag(i)==tag){
					
					var type:int=getIFDtype(i); 
					setPositionToIFDValue(i);
					
					switch(type){
						
						case 2:
							return tiff.readMultiByte(8,"utf-8");
						break;
						case 3:
							return tiff.readShort();
						break;
						case 4:
							return tiff.readInt();
						break;
					
					}
				
				}
			
			}
			return null;
		
		}
		private function setPositionToIFDValue(id:int):void{
			
			tiff.position=ifd_offset+2+id*12+8;
			
		}
		public function get order():String{
			
			return _order;
		
		}
		public function get version():int{
			
			return _ver;
		
		}
		public function get IFDNum():int{
			
			tiff.position=ifd_offset;
			return tiff.readShort();
		
		}
		public function getIFDtag(id:int):int{
			
			tiff.position=ifd_offset+2+id*12;
			return tiff.readShort();
		
		}
		public function getIFDtype(id:int):int{
			
			tiff.position=ifd_offset+2+id*12+2;
			return tiff.readShort();
		
		}
		public function getIFDcount(id:int):int{
			
			tiff.position=ifd_offset+2+id*12+2+2;
			return tiff.readInt();
		
		}
		public function get tagArray():Array{
			
			var re_array:Array=new Array
			
			for(var i:int=0;i<IFDNum;i++){
				
				re_array.push(getIFDtag(i));
			
			}
			return re_array;
		
		}
		
/*
 *                             图片属性 
 */
		public function get width():int{
			
			return getIFDContextByTag(256) as int;
		
		}
		public function get height():int{
			
			return getIFDContextByTag(257) as int;
		
		}
		//压缩方式
		public function get compress():int{
			
			return getIFDContextByTag(259) as int;
		
		}
		public function get stripOffsets():int{
			
			return getIFDContextByTag(273) as int;
		
		}
		public function get photometricInterpretation():int{
			
			return getIFDContextByTag(262) as int;
		
		}
		public function get software():String{
			
			return getIFDContextByTag(305) as String;
		
		}
		public function get StripOffsets():int{
			
			return getIFDContextByTag(273) as int;
		
		}
		public function get StripByteCounts():int{
			
			return getIFDContextByTag(279) as int;
		
		}
	}
}
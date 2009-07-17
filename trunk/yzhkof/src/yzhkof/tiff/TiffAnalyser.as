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
					var count:int=getIFDcount(i);
					setPositionToIFDValue(i);
					var off_value:int=tiff.readUnsignedInt();
					setPositionToIFDValue(i);
					
					if(count==1){
						switch(type){
							
							case 2:
								return tiff[tiff.position];
							case 3:
								return tiff.readShort();
							case 4:
								return tiff.readInt();
						
						}
					}else{
						
						var re_array:Array=new Array();
						
						switch(type){
							
							case 2:
								for (var c:int=0; c<count; c++) {
									var val:String = tiff[off_value+c];
									re_array.push(val);
								}
							break;
							case 3:
							
								for (var d:int=0; d<count; d++) {
									tiff.position=off_value+d*2;																	
									var value:int = tiff.readShort();
									re_array.push(value);
								}
							break;
							
							return re_array;						
						
						}
					
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
		public function get IFDOffset():int{
			
			return ifd_offset;
		
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
		public function get bitsPerSample():int{
			
			return getIFDContextByTag(258) as int;
		
		}
		public function get samplesPerPixel():int{
			
			return getIFDContextByTag(277) as int;
		
		}
	}
}
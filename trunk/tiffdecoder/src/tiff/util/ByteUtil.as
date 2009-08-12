package tiff.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	

	
	public class ByteUtil
	{
		public static const BYTE_SIZE:int = 1;
		public static const SHORT_SIZE:int = 2;
		public static const INT_SIZE:int = 4;
		public static const LONG_SIZE:int = 8;
				
		public function ByteUtil()
		{
		}
		public static function readFully(src:ByteArray,des:ByteArray,length:int):void{
			
			readFullyB(src,des,src.position,length)
		
		}
		public static function readFullyB(src:ByteArray,des:ByteArray,offset:int,length:int):void{
			
			src.readBytes(des,offset,length);
		
		}
		public static function isInter(inb:ByteArray):Boolean{
			
			return inb.endian==Endian.LITTLE_ENDIAN;
			
		}
		public static function readProperly(src:ByteArray,bytes:ByteArray, typeSize:int, len:int ):void {
			if (!isInter(src) || typeSize<2)
    			readFullyB(src,bytes, 0, len); 
    		else {
    			var n:int=0;
    			while ( n < len ) {
    				switch(typeSize){
    					case SHORT_SIZE:  	  					
								bytes[n+1] = src.readByte(); 
						        src.position += BYTE_SIZE;
								bytes[n] = src.readByte(); 
						        src.position += BYTE_SIZE;
								break;
		  	  			case INT_SIZE:
								bytes[n+3] = src.readByte(); 
								bytes[n+2] = src.readByte(); 
								bytes[n+1] = src.readByte(); 
								bytes[n] = src.readByte(); 
								break;
		  	  			case LONG_SIZE:
								bytes[n+7] = src.readByte(); 
								bytes[n+6] = src.readByte(); 
								bytes[n+5] = src.readByte(); 
								bytes[n+4] = src.readByte(); 
								bytes[n+3] = src.readByte(); 
								bytes[n+2] = src.readByte(); 
								bytes[n+1] = src.readByte(); 
								bytes[n] = src.readByte(); 
								break;		
    					
    				}
    				n += typeSize;
    			}
    		}			
		}

	}
}
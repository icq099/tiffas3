package tiff.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	

	/**
	 * 处理字节数组的工具类
	 * @author yzhkof
	 * 
	 */	
	public class ByteUtil
	{
		public static const BYTE_SIZE:int = 1;
		public static const SHORT_SIZE:int = 2;
		public static const INT_SIZE:int = 4;
		public static const LONG_SIZE:int = 8;
				
		public function ByteUtil()
		{
		}
		/**
		 *将源数组字节指定长度数据读写入指定数组 
		 * @param src
		 * @param des
		 * @param length
		 * 
		 */		
		public static function readFully(src:ByteArray,des:ByteArray,length:int):void{
			
			readFullyB(src,des,src.position,length)
		
		}
		/**
		 *此方法与readFully类似
		 * @param src
		 * @param des
		 * @param length
		 * 
		 */	
		public static function readFullyB(src:ByteArray,des:ByteArray,offset:int,length:int):void{
			
			src.position=offset;
			src.readBytes(des,0,length);
		
		}
		/**
		 *判断tiff图片数据是否为inter方式储存。（字节数组已作预先处理） 
		 * @param inb
		 * @return 
		 * 
		 */		
		public static function isInter(inb:ByteArray):Boolean{
			
			return inb.endian==Endian.LITTLE_ENDIAN;
			
		}
		/**
		 *从指定源数组中复制一个数组，复制从指定的位置开始，到目标数组的指定位置结束。从 src 引用的源数组到 dest 引用的目标数组，数组组件的一个子序列被复制下来。被复制的组件的编号等于 length 参数。源数组中位置在 srcPos 到 srcPos+length-1 之间的组件被分别复制到目标数组中的 destPos 到 destPos+length-1 位置。
		 * @param src
		 * @param srcPos
		 * @param dest
		 * @param desPos
		 * @param length
		 * 
		 */		
		public static function arraycopy(src:ByteArray,srcPos:int,dest:ByteArray,desPos:int,length:int):void{
			
			dest.position=desPos;
			dest.writeBytes(src,srcPos,length);
		
		}
		/**
		 *将一个无符号的8位整数转为有符号的。 
		 * @param num
		 * @return 
		 * 
		 */		
		public static function toSign(num:int):int{
			
			return num<256?(num>127?num-256:num):num;
					
		}
		public static function setLength(src:ByteArray,length:int):void{
			
			//src
		
		}
		/**
		 *实现类似于endian为Endian.LITTLE_ENDIAN的字节数组的读取方法。 
		 * @param src
		 * @param bytes
		 * @param typeSize
		 * @param len
		 * 
		 */		
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
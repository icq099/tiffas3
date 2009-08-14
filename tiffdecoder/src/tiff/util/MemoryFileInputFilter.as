package tiff.util
{
	import flash.utils.ByteArray;
	
	

	public class MemoryFileInputFilter
	{
    private var 			bytesArray:ByteArray;
    private var		isIntel:Boolean;
    private var				currentPos:int;
		public static const BYTE_SIZE:int = 1;
		public static const SHORT_SIZE:int = 2;
		public static const INT_SIZE:int = 4;
		public static const LONG_SIZE:int = 8;

    public function MemoryFileInputFilter(bytesArray:ByteArray,isIntel:Boolean) {
        this.bytesArray = bytesArray;
        this.isIntel = isIntel;
        this.currentPos = 0;
    }
    

//    public function MemoryFileInputFilter(bytesArray:ByteArray) {//方法重载
//        this.bytesArray = bytesArray;
//        this.isIntel = false;
//        this.currentPos = 0;
//    }

		public function getFilePointer():uint {
			return currentPos; 
		}

		

		public function isIntelF():Boolean {//原文的函数名是：isIntel，但是跟变量冲突
			return this.isIntel;
		}
		

		public function setByteOrder( isIntel:Boolean ):void {
			this.isIntel = isIntel;
		}
		
				

		public function readBoolean():Boolean {
			return (readByte() != 0);
		}
		

    public function readByte():int {//原文是:byte
        var b:int = ByteUtil.toSign(bytesArray[currentPos]);
        currentPos += BYTE_SIZE;
        return b;
    }

    public function seek(pos:uint):void {
    	currentPos = uint(pos); 
    }

 		public function length():uint {
 			return bytesArray.length; 
 		}

 		public function close():void {
 			bytesArray = null;
 		}
	}
}
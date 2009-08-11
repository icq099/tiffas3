package tiff.util
{
	import flash.utils.ByteArray;
	
	
/** 
 * <b>MemoryFileInputFilter</b> allows you to read from a byte array as if it was a byte array.
 * It has built in support for intel vs. motorola byte order (hi to lo / lo to hi).
 *
 * @author 
 * @version %I%, %G%
 * @see java.io.RandomAccessFile
 */
	public class MemoryFileInputFilter
	{
    private var 			bytesArray:ByteArray;
    private var		isIntel:Boolean;
    private var				currentPos:int;
		public static const BYTE_SIZE:int = 1;
		public static const SHORT_SIZE:int = 2;
		public static const INT_SIZE:int = 4;
		public static const LONG_SIZE:int = 8;
		/** 
		 * Creates a new byte array input filter that reads data from the specified byte array in the specified byte order.      
		 * @param     bytesArray  the byte array to read from.
		 * @param     isIntel  the byte order to use.
     */
    public function MemoryFileInputFilter(bytesArray:ByteArray,isIntel:Boolean) {
        this.bytesArray = bytesArray;
        this.isIntel = isIntel;
        this.currentPos = 0;
    }
    
		/** 
		 * Creates a new byte array input filter that reads data from the specified byte array.
		 * <i>the default byte order is motorola (ie lo to hi)</i>
		 * @param     bytesArray  the byte array to read from.
     */
//    public function MemoryFileInputFilter(bytesArray:ByteArray) {//方法重载
//        this.bytesArray = bytesArray;
//        this.isIntel = false;
//        this.currentPos = 0;
//    }
		/** 
     * Returns the current index in the byte array.
          * @return    the current index.
     */
		public function getFilePointer():uint {
			return currentPos; 
		}

		
		/** 
     * Returns the current byte order.
          * @return    true if intel (hi to lo), false if motorola (lo to hi).
     */
		public function isIntelF():Boolean {//原文的函数名是：isIntel，但是跟变量冲突
			return this.isIntel;
		}
		
			/** 
     * Set the current byte order.
          * @param	isIntel    true if intel (hi to lo), false if motorola (lo to hi).
     */
		public function setByteOrder( isIntel:Boolean ):void {
			this.isIntel = isIntel;
		}
		
				
		/**
		 * Reads a boolean from this byte array. This method reads a single byte from the byte array. A value of 0 represents
     * false. Any other value represents true.
     			* @return the boolean value read.
		 */
		public function readBoolean():Boolean {
			return (readByte() != 0);
		}
		
				/**
		 * Reads a signed 8-bit value from this byte array. This method reads a 
		 * byte from the byte array. If the byte read is <code>b</code>, where 
 	   * <code>0&nbsp;&lt;=&nbsp;b&nbsp;&lt;=&nbsp;255</code>, 
 	   * then the result is:
 	   * <blockquote><pre>
     	   * (byte)(b)
 	   * </pre></blockquote>
 	   */
    public function readByte():int {//原文是:byte
        var b:int = bytesArray[currentPos];
        currentPos += BYTE_SIZE;
        return b;
    }
    		/** 
     * Returns the length in the byte array.
          * @return    the length of the byte array.
     */
 		public function length():uint {
 			return bytesArray.length; 
 		}
		/** 
     * Resets the byte array to null (ie. closes it).
     */
 		public function close():void {
 			bytesArray = null;
 		}
	}
}
package tiff
{
	import flash.utils.ByteArray;
	
	/**
	 *此类定义了一些解码时需要用到的数据类型
	 * @author yzhkof
	 * 
	 */	
	public class DataType
	{
		public var type:int;
		
		public static const	MINIMUM:int		= 0;
		public static const	NOTYPE:int		= 0;	
		public static const	BYTE:int		= 1;	
		public static const	ASCII:int		= 2;
		public static const	SHORT:int		= 3;
		public static const	LONG:int		= 4;
		public static const	RATIONAL:int	= 5;
		public static const	SBYTE:int		= 6;
		public static const	UNDEFINED:int	= 7;
		public static const	SSHORT:int		= 8;
		public static const	SLONG:int		= 9;
		public static const	SRATIONAL:int	= 10;
		public static const	FLOAT:int		= 11;
		public static const	DOUBLE:int		= 12;
		public static const MAXIMUM:int		= 12; 
		public function DataType(n:int=NOTYPE)
		{
			type=n;
			if ( n < MINIMUM || n > MAXIMUM ) {
				trace( "WARNING: Unknown Data Type " + n ); 
			}
		}
		public function isAscii():Boolean {
			return type == ASCII;
		}
		
		public function isRational():Boolean {
			return type == RATIONAL || type == SRATIONAL;
		}
	
		public function isShort():Boolean {
			return type == SHORT || type == SSHORT;
		}
	
		public function isLong():Boolean {
			return type == LONG || type == SLONG;
		}
		
		public function equals( n:int ):Boolean {
			return type == n;
		}
		public function read(inb:ByteArray):void{
			type=inb.readUnsignedShort();		
		}
		public function size():int{
			return -1;
		}

	}
}
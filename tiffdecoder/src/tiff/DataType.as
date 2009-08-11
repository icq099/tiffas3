package tiff
{
	import flash.utils.ByteArray;
	
	public class DataType
	{
		public var type:int;
		
		public static const	MINIMUM:int		= 0;
		public static const	NOTYPE:int		= 0;	/* placeholder */
		public static const	BYTE:int			= 1;	/* 8-bit unsigned integer */
		public static const	ASCII:int			= 2;	/* 8-bit bytes w/ last byte null */
		public static const	SHORT:int			= 3;	/* 16-bit unsigned integer */
		public static const	LONG:int			= 4;	/* 32-bit unsigned integer */
		public static const	RATIONAL:int	= 5;	/* 64-bit unsigned fraction */
		public static const	SBYTE:int			= 6;	/* !8-bit signed integer */
		public static const	UNDEFINED:int	= 7;	/* !8-bit untyped data */
		public static const	SSHORT:int		= 8;	/* !16-bit signed integer */
		public static const	SLONG:int			= 9;	/* !32-bit signed integer */
		public static const	SRATIONAL:int	= 10;	/* !64-bit signed fraction */
		public static const	FLOAT:int			= 11;	/* !32-bit IEEE floating point */
		public static const	DOUBLE:int		= 12;	/* !64-bit IEEE floating point */
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
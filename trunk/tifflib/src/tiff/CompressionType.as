package tiff
{
	/**
	 * 
	 * 定义图片的压缩方式(留英文说明)
	 * @author yzhkof
	 * 
	 */	
	public class CompressionType
	{
		public var id:int;
		public static const	    NONE:int		=1;		/* dump mode */
		public static const	    CCITTRLE:int	=2;		/* CCITT modified Huffman RLE */
		public static const	    CCITTFAX3:int	=3;		/* CCITT Group 3 fax encoding */
		public static const	    CCITTFAX4:int	=4;		/* CCITT Group 4 fax encoding */
		public static const	    LZW:int			=5;		/* Lempel-Ziv  & Welch */
		public static const	    OJPEG:int		=6;		/* !6.0 JPEG */
		public static const	    JPEG:int		=7;		/* %JPEG DCT compression */
		public static const	    NEXT:int		=32766;	/* NeXT 2-bit RLE */
		public static const	    CCITTRLEW:int	=32771;	/* #1 w/ word alignment */
		public static const	    PACKBITS:int	=32773;	/* Macintosh RLE */
		public static const	    THUNDERSCAN:int	=32809;	/* ThunderScan RLE */

	}
}
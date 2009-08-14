package tiff.tag
{
	public class CompressionType
	{
	public var id:int;
	public static const NONE:int		=1;		/* dump mode */
	public static const CCITTRLE:int	=2;		/* CCITT modified Huffman RLE */
	public static const CCITTFAX3:int	=3;		/* CCITT Group 3 fax encoding */
	public static const CCITTFAX4:int	=4;		/* CCITT Group 4 fax encoding */
	public static const LZW:int			=5;		/* Lempel-Ziv  & Welch */
	public static const OJPEG:int		=6;		/* !6.0 JPEG */
	public static const JPEG:int		=7;		/* %JPEG DCT compression */
	public static const NEXT:int		=32766;	/* NeXT 2-bit RLE */
	public static const CCITTRLEW:int	=32771;	/* #1 w/ word alignment */
	public static const PACKBITS:int	=32773;	/* Macintosh RLE */
	public static const THUNDERSCAN:int	=32809;	/* ThunderScan RLE */
/* codes 32895-32898 are reserved for ANSI IT8 TIFF/IT <dkelly@etsinc.com) */
	public static const IT8CTPAD:int	=32895;  /* IT8 CT w/padding */
	public static const IT8LW:int		=32896;  /* IT8 Linework RLE */
	public static const IT8MP:int		=32897;  /* IT8 Monochrome picture */
	public static const IT8BL:int		=32898;  /* IT8 Binary line art */
/* compression codes 32908-32911 are reserved for Pixar */
	public static const PIXARFILM:int	=32908;  /* Pixar companded 10bit LZW */
	public static const PIXARLOG:int	=32909;  /* Pixar companded 11bit ZIP */
	public static const DEFLATE:int		=32946;	/* Deflate compression */
/* compression code 32947 is reserved for Oceana Matrix <dev@oceana.com> */
	public static const DCS:int         =32947;  /* Kodak DCS encoding */
	public static const JBIG:int		=34661;	/* ISO JBIG */

	public function CompressionType(n:int=0 ) {
		id = n;
	}

	public function toString():String {//默认的toString
		switch (id) {
			case NONE: 			return "NONE";
			case CCITTRLE	:	return "CCITT RLE";
			case CCITTFAX3:	return "CCITT FAX 3";			
			case CCITTFAX4:	return "CCITT FAX 4";
			case LZW: 			return "LZW";		
			case OJPEG: 		return "old JPEG";		
			case JPEG: 			return "new JPEG";		
			case NEXT: 			return "NeXT";	
			case CCITTRLEW:	return "CCITT RLE/W";	
			case PACKBITS:	return "PACKBITS";	
			case THUNDERSCAN:	return "ThunderScan";	
			default: return "other";
		}		
	}
	
	public static function toString( n:int ):String {
		switch (n) {
			case NONE: 			return "NONE";
			case CCITTRLE	:	return "CCITT RLE";
			case CCITTFAX3:	return "CCITT FAX 3";			
			case CCITTFAX4:	return "CCITT FAX 4";
			case LZW: 			return "LZW";		
			case OJPEG: 		return "old JPEG";		
			case JPEG: 			return "new JPEG";		
			case NEXT: 			return "NeXT";	
			case CCITTRLEW:	return "CCITT RLE/W";	
			case PACKBITS:	return "PACKBITS";	
			case THUNDERSCAN:	return "ThunderScan";	
			default: return n.toString();//原文是Integer.toHexString()
		}		
	}
	}
}
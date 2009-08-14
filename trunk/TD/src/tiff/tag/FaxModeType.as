package tiff.tag
{
	public class FaxModeType
	{
	public static const CLASSIC:int			=0x0000;	/* default, include RTC */
	public static const NORTC:int			=0x0001; 	/* no RTC at end of data */
	public static const NOEOL:int			=0x0002;	/* no EOL code at end of row */
	public static const BYTEALIGN:int		=0x0004;	/* byte align row */
	public static const WORDALIGN:int		=0x0008;	/* word align row */
	public static const CLASSF:int			=0x0001; 	// NORTC	/* TIFF Class F */
	}
}
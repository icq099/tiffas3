package tiff.tag
{
	public class PhotometricType
	{
	public static const MINISWHITE:int	=0;	/* min value is white */
	public static const MINISBLACK:int	=1;	/* min value is black */
	public static const RGB:int			=2;	/* RGB color model */
	public static const PALETTE:int		=3;	/* color map indexed */
	public static const MASK:int		=4;	/* $holdout mask */
	public static const SEPARATED:int	=5;	/* !color separations */
	public static const YCBCR:int		=6;	/* !CCIR 601 */
	public static const CIELAB:int		=8;	/* !1976 CIE L*a*b* */
	}
}
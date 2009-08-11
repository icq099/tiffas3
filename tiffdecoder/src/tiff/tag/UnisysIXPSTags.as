package tiff.tag
{
	public class UnisysIXPSTags
	{
    public static const VERSION:int			= 1; /*Version*/
    public static const SIDI:int			= 2; /*SIDI*/
    public static const DATE:int			= 10; /*Processing Date*/
    public static const CDLINE:int			= 11; /*cdline and amt id*/
    public static const AMOUNT:int			= 12; /*Amount*/
    public static const DIN:int				= 101; /*DIN*/
    public static const SERIAL:int			= 102; /*Check Serial Number*/
    public static const ACCOUNT:int			= 516; /*Account Number*/
    public static const AUXONUS:int			= 517; /*Aux on Us*/
    public static const POS44:int			= 518; /*Position 44*/
    public static const TRANSIT:int			= 519; /*Routing and Transit*/
    public static const TRANCODE:int		= 520; /*TranCode*/
    public static const USER:int			= 32000; /*IXPS User Area*/


    var id:int;

    public function UnisysIXPSTags( i:int ) {
    	id = i;
    }

    public function toString():String  {
    	var sz:String ;
    	switch (id) {
			case VERSION: 	sz="Version             "; break;
			case SIDI: 		sz="SIDI                "; break;
			case CDLINE: 	sz="cdline and amt id   "; break;
			case DIN: 		sz="DIN                 "; break;
			case SERIAL: 	sz="Check Serial Number "; break;
			case DATE: 		sz="Processing Date     "; break;
			case AMOUNT: 	sz="Check Amount        "; break;
			case TRANCODE: 	sz="Transaction Code    "; break;
			case ACCOUNT: 	sz="Account Number      "; break;
			case TRANSIT: 	sz="Transit Transit     "; break;
			case AUXONUS: 	sz="Auxiliary On Us     "; break;
			case POS44: 	sz="Position 44         "; break;
			case USER: 		sz="User Area           "; break;
			default: sz="Unknown Unisys IXPS tag: "+id; break;
    	}
    	return sz;
    }
	}
}
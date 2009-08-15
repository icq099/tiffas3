package tiff.tag
{
public class UnisysISISTags
{
	public static const DIN:int			= 1; /*DIN*/
    public static const SERIAL:int		= 2; /*Check Serial Num*/
    public static const DATE:int		= 3; /*Processing Date*/
    public static const AMOUNT:int		= 4; /*Check Amount*/
    public static const TRANCODE:int	= 5; /*Transaction Code*/
    public static const ACCOUNT:int		= 6; /*Account Number*/
    public static const TRANSIT:int		= 7; /*Transit Transit*/
    public static const AUXONUS:int		= 8; /*Auxiliary On Us*/
    public static const POS44:int		= 9; /*Position 44*/
    public static const DATE2:int		= 10; /*Processing Date*/
    public static const USER:int		= 11; /*User Area*/

    public var  id:int;
    
    public function UnisysISISTags(i:int ) {
    	id = i; 
    }
    
    public function toString():String {
    	var sz:String; 
    	switch (id) {
    		case DIN: 		sz="DIN"; break; 
    		case SERIAL: 	sz="Check Serial Num"; break; 
    		case DATE: 		sz="Processing Date"; break; 
    		case AMOUNT: 	sz="Check Amount"; break; 
    		case TRANCODE: 	sz="Transaction Code"; break; 
    		case ACCOUNT: 	sz="Account Number"; break; 
    		case TRANSIT: 	sz="Transit Transit"; break; 
    		case AUXONUS: 	sz="Auxiliary On Us"; break; 
    		case POS44: 	sz="Position 44"; break; 
    		case DATE2: 	sz="Processing Date"; break; 
    		case USER: 		sz="User Area"; break; 
    		default: sz="Unknown Unisys ISIS tag: "+id; break; 
    	}
    	return sz; 
    }
}
}
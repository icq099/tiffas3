package tiff.tag
{
	public class UnisysISISUserTags
	{
    public static const USERID:int  	=  0; /*User ID*/
    public static const SITEID:int  	=  1; /*Site ID*/
    public static const START:int  		=  2; /*Capture Start*/
    public static const PID:int   		=  3; /*Capture PID*/
    public static const DOCID:int   	=  4; /*Document Num*/
    public static const MIGRATION:int   =  5; /*Migration Date*/
    public static const MICROFILM:int   =  6; /*Micro Film Seq*/
    public static const ITEMSEQ:int 	=  7; /*Item Seq*/
    public static const TRACER:int  	=  8; /*Tracer Number*/
    public static const SIDEID:int  	=  9; /*Side ID*/ //0=front 1=back
    public static const ZONELIST:int	=  10; /*Zone List*/
    public static const NEXTIFD:int 	=  11; /*Next Level 1 IFD offset*/
    
    internal var id:int;
    
    public function UnisysISISUserTags( i :int) {
    	id = i; 
    }
    
    public function toString():String {
    	var sz:String; 
    	switch (id) {
    		case USERID: 	sz="User ID"; break; 
    		case SITEID: 	sz="Site ID"; break; 
    		case START: 	sz="Capture Start"; break; 
    		case PID: 		sz="Capture PID"; break; 
    		case DOCID: 	sz="Document Num"; break; 
    		case MIGRATION: sz="Migration Date"; break; 
    		case MICROFILM: sz="Micro Film Seq"; break; 
    		case ITEMSEQ: 	sz="Item Seq"; break; 
    		case TRACER: 	sz="Tracer Number"; break; 
    		case SIDEID: 	sz="Side ID"; break;  //0=front 1=back
    		case ZONELIST: 	sz="Zone List"; break; 
    		case NEXTIFD: 	sz="Next Level 1 IFD offset"; break; 
    		default: sz="Unknown Unisys ISIS User tag"; break; 
    	}
    	return sz; 
    }
	}
}
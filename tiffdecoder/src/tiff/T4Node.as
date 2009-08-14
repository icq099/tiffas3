package tiff
{

public class T4Node {
	
	public static const NOMASK:int= 0xffff; 
	
	internal var mask:int;
	internal var zero:T4Node;
	internal var one:T4Node;
	internal var code:T4Code;
	
	public function T4Node() {
		mask = 0xffff;
		zero = null;
		one = null;
		code = null;
	}

	/* public function toString():String{
		var sz:StringBuffer= new StringBuffer();
		var szMask:String= Converter.intToBinaryString(mask,16);
		var i:int= (mask!=NOMASK ? szMask.indexOf("1") : code.bitLength);
		sz.append("\n");
		for (;i>0; i--) sz.append(" ");
		sz.append( "{" );
		sz.append( szMask ); 
		sz.append( "," );
//		if (zero==null) sz.append("null");
//		else sz.append( zero.toString() );
		sz.append( zero ); 
		sz.append( "," );
//		if (one==null) sz.append("null");
//		else sz.append( one.toString() );
		sz.append( one ); 
		sz.append( "," );
		sz.append( code );
		sz.append( "}" );
		return sz.toString();
	} */
	
	public function Add( d:int, c:T4Code):void{
		if (d == c.bitLength) { //end of the line
			code = c;
//			trace("Added T4Node for "+c);
		}
		else {
			d++;
			if (mask == NOMASK) {
				mask = 1<<( 16-d ); 
//				trace("Added ");
			}

			var bits:int= c.codeWord << (16-c.bitLength); 

//			trace("mask (" 
//				+ Converter.intToBinaryString(mask,16) + ") T4Node for "
//				+ Converter.intToBinaryString(bits,16));
				
			if ((bits & mask) == 0) {
//				trace(" --> add to zero side");
				if (zero == null)
					zero = new T4Node(); 
				zero.Add( d, c );
			}
			else {
//				trace(" --> add to ones side");
				if (one == null)
					one = new T4Node(); 
				one.Add( d, c );
			}
		}
	}


	public function ReversedAdd( d:int, c:T4Code):void{
		if (d == c.bitLength) { //end of the line
			code = c;
//DEBUG			trace("Added T4Node for "+c);
		}
		else {
			if (mask == NOMASK) {
				mask = 1<<d; 
//DEBUG				trace("MASK ");
			}
//DEBUG			else trace("mask "); 
			d++;

			var bits:int= c.codeWord;
			
//DEBUG			trace("(" 
//DEBUG				+ Converter.intToBinaryString(mask,16) + ") T4Node for "
//DEBUG				+ Converter.intToBinaryString(bits,16));
				
			if ((bits & mask) == 0) {
//DEBUG				trace(" --> add to zero side");
				if (zero == null)
					zero = new T4Node(); 
				zero.ReversedAdd( d, c );
			}
			else {
//DEBUG				trace(" --> add to ones side");
				if (one == null)
					one = new T4Node(); 
				one.ReversedAdd( d, c );
			}
		}
	}
	
	
	public function Find( i:int):T4Node{
		if (code != null) {
//DEBUG			trace( "found it: "+code );
			return this;
		}
		else if (mask != NOMASK) {
			if ((mask & i)==0) {
//DEBUG				trace( "look on zero side");
				return (zero!=null ? zero.Find( i ) : null);
			}
			else {
//DEBUG				trace( "look on ones side");
				return (one!=null ? one.Find( i ) : null);
			}
		}
		else return null;
	}
	
}
}
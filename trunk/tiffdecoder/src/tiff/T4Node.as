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
//			System.out.println("Added T4Node for "+c);
		}
		else {
			d++;
			if (mask == NOMASK) {
				mask = 1<<( 16-d ); 
//				System.out.print("Added ");
			}

			var bits:int= c.codeWord << (16-c.bitLength); 

//			System.out.print("mask (" 
//				+ Converter.intToBinaryString(mask,16) + ") T4Node for "
//				+ Converter.intToBinaryString(bits,16));
				
			if ((bits & mask) == 0) {
//				System.out.println(" --> add to zero side");
				if (zero == null)
					zero = new T4Node(); 
				zero.Add( d, c );
			}
			else {
//				System.out.println(" --> add to ones side");
				if (one == null)
					one = new T4Node(); 
				one.Add( d, c );
			}
		}
	}


	public function ReversedAdd( d:int, c:T4Code):void{
		if (d == c.bitLength) { //end of the line
			code = c;
//DEBUG			System.out.println("Added T4Node for "+c);
		}
		else {
			if (mask == NOMASK) {
				mask = 1<<d; 
//DEBUG				System.out.print("MASK ");
			}
//DEBUG			else System.out.print("mask "); 
			d++;

			var bits:int= c.codeWord;
			
//DEBUG			System.out.print("(" 
//DEBUG				+ Converter.intToBinaryString(mask,16) + ") T4Node for "
//DEBUG				+ Converter.intToBinaryString(bits,16));
				
			if ((bits & mask) == 0) {
//DEBUG				System.out.println(" --> add to zero side");
				if (zero == null)
					zero = new T4Node(); 
				zero.ReversedAdd( d, c );
			}
			else {
//DEBUG				System.out.println(" --> add to ones side");
				if (one == null)
					one = new T4Node(); 
				one.ReversedAdd( d, c );
			}
		}
	}
	
	
	public function Find( i:int):T4Node{
		if (code != null) {
//DEBUG			System.out.println( "found it: "+code );
			return this;
		}
		else if (mask != NOMASK) {
			if ((mask & i)==0) {
//DEBUG				System.out.println( "look on zero side");
				return (zero!=null ? zero.Find( i ) : null);
			}
			else {
//DEBUG				System.out.println( "look on ones side");
				return (one!=null ? one.Find( i ) : null);
			}
		}
		else return null;
	}
	
}
}
package tiff
{
	import flash.utils.ByteArray;
	

public final class Converter {

/*
	public static byte reverseByte( int oldBits ) {
		int i,d,bits;
		for (i=0,d=1,bits=0; i<8; i++,d=d<<1) {
			if ( (oldBits&d) != 0 ) {
				bits += 1 << (7-i);
			}
		}
		
		return (byte)( bits & 0xff);
	}
*/

	public static function reverseByte( oldBits:int):int{
		var i:int,d:int,bits:int;
		for (i=0,d=1,bits=0; i<8; i++,d=d<<1) {
			if ( (oldBits&d) != 0) {
				bits += 1<< (7-i);
			}
		}
		
		return bits; 
	}

	public static function reverseInt( oldBits:int):int{
		var i:int,d:int,bits:int;
		for (i=0,d=1,bits=0; i<16; i++,d=d<<1) {
			if ( (oldBits&d) != 0) {
				bits += 1<< (15-i);
			}
		}
		
		return bits; 
	}

	public static function getLoByte( n:int):uint{
		return  n & 0xff;
	}

	public static function getHiByte( n:int):uint{
		return  (n & 0xff00) >> 8;
	} 

	public static function bytesToInt( ba:ByteArray):int{
		if (ba.length<2) {
			trace("bytesToInt: byte array must be at least 2 bytes long");
			return 0;
		}
		var hi:int= int((ba[0] & 0xff)<< 8);
		var lo:int= int(ba[1] & 0xff);
		return (hi + lo);
	}
	
/* 	public static function byteToBinaryString( b:uint):String{
		var szZeros:String= "00000000";
		var szBits:String= Integer.toString(int((b & 0xff)),2);
		var sz:String= szZeros.substring( szBits.length() ) + szBits;
//		return sz.substring(0,4)+" "+sz.substring(4,8);
		return sz;
	}

	public static function byteToBinaryStringB( i:int):String{
		var szZeros:String= "00000000";
		var szBits:String= Integer.toString(int((i & 0xff)),2);
		var sz:String= szZeros.substring( szBits.length() ) + szBits;
//		return sz.substring(0,4)+" "+sz.substring(4,8);
		return sz;
	} 

	public static function byteToBinaryStringC( i:int, len:int):String{
		return byteToBinaryString( i ).substring(8-len); 
	}*/

	/* public static function intToBinaryString( i:int, len:int):String{
		var szLo:String= byteToBinaryString(i&0xff);
		var szHi:String= byteToBinaryString((i&0xff00)>>8);
		var szBits:String= szHi + szLo;		
		
		return szBits.substring(16-len); 
	} */

	/* public static function getLoByteFromHexString( szHex:String):uint{
		var n:int= Integer.parseInt(szHex, 16);
		return (n& 0xff00)>>8;
	}

	public static function getHiByteFromHexString( szHex:String):uint{
		var n:int= Integer.parseInt(szHex, 16);
		return (byte)( (n & 0x00) >> 8);
	}  */

	/* public static function getByteFromHexString( szHex:String):uint{
		return getLoByteFromHexString( szHex );
	} */
	
	/* public static function hexStringToBytes(szHex:String):ByteArray {
		var tokens:StringTokenizer= new StringTokenizer( szHex, ", " );
		var i:int,count = tokens.countTokens();
		var bytes:ByteArray = new ByteArray;
		for (i=0; i<count && tokens.hasMoreTokens(); i++) {
			bytes[i] = getByteFromHexString( tokens.nextToken() ); 
		}
		return bytes;
	} */

	/* public static function getByteFromBinaryString( szBinary:String):uint{
		var n:int= Integer.parseInt(szBinary, 2);
		return (byte)( n & 0xff);
	}

	public static function binaryStringToBytes(szBinary:String):ByteArray {
		var tokens:StringTokenizer= new StringTokenizer( szBinary, ", " );
		var i:int,count = tokens.countTokens();
		var bytes:ByteArray = new ByteArray;
		for (i=0; i<count && tokens.hasMoreTokens(); i++) {
			bytes[i] = getByteFromBinaryString( tokens.nextToken() ); 
		}
		return bytes;
	} */
	
	 public static function getBits( octet:ByteArray, len:int):int{
		//trace( "\ngetBits ("+byteToBinaryString(octet[0])+"_"+byteToBinaryString(octet[1])+", "+len+")"); 
		var bits:int=0,hi:int,lo:int;
		switch (len) {
			case 1: case 2:	case 3: case 4: case 5: case 6: case 7: 
				bits = int((octet[0] & 0xff) )>>> (8-len);
//				trace("\t"+byteToBinaryString(octet[0])+" >>> " + (8-len) + " = " + byteToBinaryString(bits,len)+"\n");
				break; 
			case 8:
				bits = octet[0];
//				trace("\t"+byteToBinaryString(octet[0])+ " = " + byteToBinaryString(bits,len)+"\n");
				break; 			
			case 9: case 10: case 11: case 12: case 13: case 14: case 15:
				var shift:int= (8-(len-8));
				hi = (int((octet[0] & 0xff) )<< 8);
				lo = int((octet[1] & 0xff));
				bits = (hi + lo) >>> shift;
				
//				trace("\t "+ intToBinaryString(hi,16)); 
//				trace("\t+"+ intToBinaryString(lo,16));
//				trace("\t="+ intToBinaryString(hi+lo,16) );
//				trace("\t >>> " + shift); 
//				trace("\t\t==>" + intToBinaryString(bits,len)+"\n");
				break; 
			case 16:
				hi = (int((octet[0] & 0xff) )<< 8);
				lo = int((octet[1] & 0xff));
				bits = (hi + lo);
//				trace("\t "+ intToBinaryString(hi,16)); 
//				trace("\t+"+ intToBinaryString(lo,16));
//				trace("\t="+ intToBinaryString(hi+lo,16) );
				break; 				
		}
		return bits;
	}

	public static function getBitsB( number:int, len:int):int{
		//trace( "\ngetBits ("+intToBinaryString(number,16)+", "+len+")"); 
		var octet:ByteArray = new  ByteArray;
		octet[0] = getHiByte(number);
		octet[1] = getLoByte(number);
		return getBits( octet, len ); 
	} 

}
}
package tiff
{
	import flash.utils.ByteArray;
	

public final class Converter {


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
	
	
	 public static function getBits( octet:ByteArray, len:int):int{
		var bits:int=0,hi:int,lo:int;
		switch (len) {
			case 1: case 2:	case 3: case 4: case 5: case 6: case 7: 
				bits = int((octet[0] & 0xff) )>>> (8-len);
				break; 
			case 8:
				bits = octet[0];
				break; 			
			case 9: case 10: case 11: case 12: case 13: case 14: case 15:
				var shift:int= (8-(len-8));
				hi = (int((octet[0] & 0xff) )<< 8);
				lo = int((octet[1] & 0xff));
				bits = (hi + lo) >>> shift;
				
				break; 
			case 16:
				hi = (int((octet[0] & 0xff) )<< 8);
				lo = int((octet[1] & 0xff));
				bits = (hi + lo);
				break; 				
		}
		return bits;
	}

	public static function getBitsB( number:int, len:int):int{
		
		var octet:ByteArray = new  ByteArray;
		octet[0] = getHiByte(number);
		octet[1] = getLoByte(number);
		return getBits( octet, len ); 
	} 

}
}
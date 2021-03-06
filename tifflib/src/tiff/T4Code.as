package tiff
{
import flash.utils.ByteArray;

/**
 * 
 * CCITT T.4 1D Huffman运行长度码与相关的定义
 * @author Administrator
 * 
 */ 
public class T4Code {


	public static const EOL:int= -1;	/* NB: ACT_EOL - ACT_WRUNT */
	public static const INVALID:int= -2;	/* NB: ACT_INVALID - ACT_WRUNT */
	public static const EOF:int= -3;	/* end of input data */
	public static const INCOMP:int= -4;	/* incomplete run code */

  public var bitLength:int;		/* bit bitLength of g3 code */
  public var codeWord:int;			/* g3 codeWord */
  public var runLength:int;		/* run length in bits */
  
  public function T4Code(){
  		bitLength=0;
	  	codeWord=0;
	  	runLength=0;
  }
 public function T4CodeB( c:T4Code):void {
		if (c != null) {
			bitLength = c.bitLength;
			codeWord = c.codeWord;
			runLength = c.runLength;
		}
		else {
	  	bitLength=0;
	  	codeWord=0;
	  	runLength=0;
		}
	}
  public function T4CodeC(l:int, c:int, r:int):void {
  	bitLength=l;
  	codeWord=c;
  	runLength=r;
  }

  public function T4CodeD(codeArray:Array):void {
  	if (codeArray.length == 3) {
	  	bitLength=codeArray[0];
	  	codeWord=codeArray[1];
	  	runLength=codeArray[2];
	  }
		else {
	  	bitLength=0;
	  	codeWord=0;
	  	runLength=0;
		}
  }

	public function T4CodeE( octet:ByteArray, whiteRun:Boolean):void {
		this();
		var c:T4Code= getCode( octet, whiteRun ); 
		if (c != null) {
			bitLength = c.bitLength;
			codeWord = c.codeWord;
			runLength = c.runLength;
		}
	}

	
	
	public function getCode( octet:ByteArray, whiteRun:Boolean):T4Code{ 

		var c:T4Code= null;
		var table:Array;
		var len:int=0;
		var i:int, ca:Array;
		var bits:int=0;
		var found:Boolean= false; 
		
		if (whiteRun) {
			table = T4Tables.WhiteCodes;
			i = ( octet[0]==0? 92: 0);
		}
		else {
			table = T4Tables.BlackCodes;
			i = ( octet[0]==0? 15: 0);
		}
		for (; !found && i<table.length; i++) {

			ca = table[i];
			if (len != ca[0]){ 
				len = ca[0];
				bits = Converter.getBits( octet, len );
			}

			if (bits == ca[1]) {
				c = new T4Code();
				c.T4CodeD(ca);
				found = true;
			}
			
		}
		
		return c;
	}


}
}
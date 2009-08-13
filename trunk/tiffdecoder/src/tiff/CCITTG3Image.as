package tiff
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import tiff.util.ByteUtil;
	


/* CCITT Group 3 fax encoding */
public class CCITTG3Image extends RawImage {

	internal var WhiteTree:T4Node;
	internal var BlackTree:T4Node;
	internal var WhiteRun:ByteArray;
	internal var BlackRun:ByteArray;
	internal var hiloBitOrder:Boolean;
	internal var nPixels:int=0;


	public function CCITTG3Image(ifd:IFD) {
		super(ifd);

		var i:int;
		var code:T4Code;

		WhiteRun = new ByteArray;
		BlackRun = new ByteArray;

		for (i=0; i<2560; i++) {
			//WhiteRun[i]=0xff;
			//i%4==0?BlackRun[i]=0xff:BlackRun[i]=0;
			WhiteRun.writeUnsignedInt(0xffffffff);
			BlackRun.writeUnsignedInt(0xff000000);
		}

		hiloBitOrder = (ifd.GetFieldValue( Tag.FILLORDER ) == 2);
		WhiteTree = new T4Node();
		BlackTree = new T4Node();
		var lo:int
		//create the code lookup trees
		if (hiloBitOrder) { //thus reverse codeWords and do a reversed add to make masks correctly
			for (i=0; i<T4Tables.WhiteCodes.length; i++) {
				code = new T4Code();
				code.T4CodeD(T4Tables.WhiteCodes[i]);
				if (code.bitLength <= 8) {
					lo= Converter.reverseByte(Converter.getLoByte(code.codeWord)); // & 0xff);
					code.codeWord = (lo >>> (8-code.bitLength));
				}
				else {
					code.codeWord = (Converter.reverseInt(code.codeWord) >>> (16-code.bitLength));
				}
				WhiteTree.ReversedAdd( 0, code );
			}

			for (i=0; i<T4Tables.BlackCodes.length; i++) {
				code = new T4Code();
				code.T4CodeD(T4Tables.BlackCodes[i]);
				if (code.bitLength <= 8) {
					lo= Converter.reverseByte(Converter.getLoByte(code.codeWord)); // & 0xff);
					code.codeWord = (lo >>> (8-code.bitLength));
				}
				else {
					code.codeWord = (Converter.reverseInt(code.codeWord) >>> (16-code.bitLength));
				}
				BlackTree.ReversedAdd( 0, code );
			}
		}
		else {
			for (i=0; i<T4Tables.WhiteCodes.length; i++) {
				code = new T4Code();
				code.T4CodeD(T4Tables.WhiteCodes[i]);
				WhiteTree.Add( 0, code );
			}

			for (i=0; i<T4Tables.BlackCodes.length; i++) {
				code = new T4Code();
				code.T4CodeD(T4Tables.BlackCodes[i]);
				BlackTree.Add( 0, code );
			}
		}


	}

/**/

	public override function getImage():BitmapData{
		
		return img!=null?img:decodeAndGetImage();
	
	}
	private function decodeAndGetImage():BitmapData{

		if (imageBytes == null && imageStrips != null) {
			var i:int, n:int, len:int, rows:int, lastRow:int;

			var rowsPerStrip:int= ifd.GetFieldValue( Tag.ROWSPERSTRIP );

			imageBytes = new ByteArray;

			for (i=0,n=0,rows=0,lastRow=imageStrips.length-1; i<imageStrips.length; i++, rows+=rowsPerStrip) { //imageStrips.length

				var rawStrip:ByteArray= DecodeImageStrip( imageStrips[i], (i==lastRow ? (imageHeight-rows) : rowsPerStrip), true); //(i==0));

				ByteUtil.arraycopy(rawStrip, 0, imageBytes, n, nPixels);
				n += nPixels;
				nPixels = 0;
			}
			imageStrips = null;
		}
		else if (imageBytes != null) imageBytes = DecodeImage();
		else return null;

		/* if (bitsPerSample==8&& imageBytes!=null) {
			var cm:ColorModel= makeColorModel();
		  img = Toolkit.getDefaultToolkit().createImage(
		  	 new MemoryImageSource(imageWidth, imageHeight, cm, imageBytes, 0, imageWidth));
		} */
		if (bitsPerSample==8&& imageBytes!=null) {
		  img = new BitmapData(imageWidth, imageHeight);
		 /*  var byte:ByteArray=new ByteArray;
		  var white:ByteArray=new ByteArray;
		  var black:ByteArray=new ByteArray;
		  for(i=0;i<4;i++){
		  	
		  	white[i]=0xff;
		  	black[i]=0x00;
		  
		  }
		  black[0]=0xff; */
		  /* for(i=0;i<imageWidth;i++){
		  	for(var j:int=0;j<imageHeight;j++){		  		
		  		img.setPixel(i,j,imageBytes[i+j*imageWidth]==0?0:0xffffff);  	
		  	}
		  } */
		  imageBytes.position=0;
		  img.setPixels(new Rectangle(0,0,imageWidth,imageHeight-1),imageBytes);
		}

		return img;
	}
/**/

	/* public function getImageProducer():Object{

		if (imageBytes == null && imageStrips != null) {
			var i:int, n, len, rows, lastRow;

			var rowsPerStrip:int= ifd.GetFieldValue( Tag.ROWSPERSTRIP );

			imageBytes = new ByteArray;

			for (i=0,n=0,rows=0,lastRow=imageStrips.length-1; i<imageStrips.length; i++, rows+=rowsPerStrip) { //imageStrips.length

				var rawStrip:ByteArray = DecodeImageStrip( imageStrips[i], (i==lastRow ? (imageHeight-rows) : rowsPerStrip), true); //(i==0));

				ByteUtil.arraycopy(rawStrip, 0, imageBytes, n, nPixels);
				n += nPixels;
				nPixels = 0;
			}
			imageStrips = null;
		}
		else if (imageBytes != null) imageBytes = DecodeImage();
		else return null;


		if (bitsPerSample==8&& imageBytes!=null) {
			var imagePixels:Array= new int [imageBytes.length];
			for (var i:int=0; i<imageBytes.length; i++)
				imagePixels[i] = imageBytes[i];
	  	return new MemoryImageSource(imageWidth, imageHeight, imagePixels, 0, imageWidth);
		}

		return null;
	} */

	public function DecodeImage():ByteArray {
		trace("CCITTG3Image::DecodeImage()");
		return DecodeImageStrip( imageBytes, imageHeight, true );
	}

	public function DecodeImageStrip(imageStrip:ByteArray,maxLines:int,firstStrip:Boolean):ByteArray
	{
		trace("CCITTG3Image::DecodeImageStrip( strip, " +maxLines+" )");
		

		var i:int, j:int, shift:int, count:int;
		var bytesArray:ByteArray = imageStrip;
		var b1:int, b2:int, b3:int, tmp:ByteArray = new ByteArray;
		var whiteRun:Boolean=true;
		var lines:int=0;

		var c:T4Code, code:T4Code = new T4Code();
		var node:T4Node;

		var expectedCount:int= imageWidth*maxLines;
		var rawImage:ByteArray = new ByteArray;

		nPixels=0;

		if (firstStrip) {

//			for (i=0; i<8; i++)
//				System.out.print( " " + Converter.byteToBinaryString( ByteUtil.toSign(bytesArray[*]) ) );
//			trace();

			//skip over first eol which starts the encoded image
			for (i=0,j=0;bytesArray[i]==0; i++) {;}
			j=i;


			if (hiloBitOrder) {
				var b:int= Converter.reverseByte(ByteUtil.toSign(bytesArray[j]));
				for (i=0; (b>>i) != 1;i++) {;}
			}
			else {
				for (i=0; (ByteUtil.toSign(bytesArray[j])>>i) != 1;i++) {;}
			}
			i += j*8;
		}
		else {
			i=0;
		}

		//go through the whole thing
		for (lines=1,count=bytesArray.length*8; lines<maxLines && i<count; ) {

			//i is the bit index, j is the byte index, shift is amount to shift over in byte j
			j = i/8;
			shift = (i%8);

			//grab the next few bytes to get bytes to search on
			b1=ByteUtil.toSign(bytesArray[j]);
			b2=(j+1<bytesArray.length ? ByteUtil.toSign(bytesArray[j+1]) : 0);
			b3=(j+2<bytesArray.length ? ByteUtil.toSign(bytesArray[j+2]) : 0);
			//trace(bytesArray[j+2],ByteUtil.toSign(bytesArray[j+2]),bytesArray.position=j+2,bytesArray.readByte());
			//shift bytes if necessary
			if (hiloBitOrder) {
				if (shift>0) {
					tmp[1] = (int(b1 & 0xff) >>> shift)+   (int(b2 & (0xff >>> 8-shift)) << 8-shift );
					tmp[0] = (int(b2 & 0xff) >>> shift )+ (int(b3 & (0xff >>> 8-shift)) << 8-shift );
				}
				else {
					tmp[1] = b1;
					tmp[0] = b2;
				}
			}
			else {
				if (shift>0) {
					tmp[0] = (int(b1 & 0xff) << shift ) + ( int(b2 & 0xff) >> 8-shift );
					tmp[1] = (int(b2 & 0xff) << shift ) + ( int(b3 & 0xff) >> 8-shift );
				}
				else {
					tmp[0] = b1;
					tmp[1] = b2;
				}
			}
			//find the code using our code trees
			if (whiteRun) node=WhiteTree.Find(Converter.bytesToInt(tmp));
			else 	node=BlackTree.Find(Converter.bytesToInt(tmp));
			
			if (node != null)
				code = node.code;
				
			//set the image bytes based on the code's runlength
				if (code.runLength>0) {					
					//ByteUtil.arraycopy( (whiteRun ? WhiteRun : BlackRun), 0, rawImage, nPixels, code.runLength );
					ByteUtil.arraycopy( (whiteRun ? WhiteRun : BlackRun), 0, rawImage, nPixels, code.runLength*4 );
					nPixels += code.runLength*4;
				}

			//increment our bit index
			i += code.bitLength;

			//if at end of file, decrement line count (remember, skipped over first line (just eol code))
			if (code.runLength==T4Code.EOF) {
				lines --;
				break; //reached the end of the image!
			}


//DEBUG			System.out.print((whiteRun ? " W" : " B") + code.runLength);
//DEBUG			if (code.runLength<0)
//DEBUG				trace(code);

			//if at the end of the line
			if (nPixels > 0&& code.runLength==T4Code.EOL ) //end of the line
				{
				whiteRun = true; //always start with a white run
				lines++;

//DEBUG				trace();
				}
			else if (code.runLength<64) //if terminating code
				whiteRun = !whiteRun;			//switch run type (white/black)

		}

//DEBUG		trace("nPixels = "+nPixels+", rawImage.length="+rawImage.length+", lines="+lines+", maxLines="+maxLines+", imageWidth="+imageWidth);
		//TimeCounter.traceResult()
		bitsPerSample=8;
		return (rawImage);
	}

}
}
package tiff
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import tiff.util.ByteUtil;	

/**
 * 此类为g3t4解析的核心类
 *g3t4主要编码方式为改良huffman树编码，与运行长度编码。
 * 
 * @author yzhkof
 * 
 */
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
		//初始化黑白两色最大运行长度图像像素字节数组，以便写入图片字节数组。
		WhiteRun = new ByteArray;
		BlackRun = new ByteArray;

		for (i=0; i<2560; i++) {
			WhiteRun.writeUnsignedInt(0xffffffff);
			BlackRun.writeUnsignedInt(0xff000000);
		}

		hiloBitOrder = (ifd.GetFieldValue( Tag.FILLORDER ) == 2);
		WhiteTree = new T4Node();
		BlackTree = new T4Node();
		var lo:int
		
		if (hiloBitOrder) {
			for (i=0; i<T4Tables.WhiteCodes.length; i++) {
				code = new T4Code();
				code.T4CodeD(T4Tables.WhiteCodes[i]);
				if (code.bitLength <= 8) {
					lo= Converter.reverseByte(Converter.getLoByte(code.codeWord)); 
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
					lo= Converter.reverseByte(Converter.getLoByte(code.codeWord));
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
	/**
	 * 
	 *获得CCITTG3图像的bitmapdata对象。 
	 * @return 
	 * 
	 */	
	public override function getImage():BitmapData{
		
		return img!=null?img:decodeAndGetImage();//如果已经解过码，则返回缓存数据;
	
	}
	/**
	 * 此函数为g3t4主要解析方法
	 * @return 
	 * 
	 */	
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
		
		if (bitsPerSample==8&& imageBytes!=null) {
		  img = new BitmapData(imageWidth, imageHeight);
		  
		  imageBytes.position=0;
		  img.setPixels(new Rectangle(0,0,imageWidth,imageHeight-1),imageBytes);
		}

		return img;
	}
	public function DecodeImage():ByteArray {
		//trace("CCITTG3Image::DecodeImage()");
		return DecodeImageStrip( imageBytes, imageHeight, true );
	}

	public function DecodeImageStrip(imageStrip:ByteArray,maxLines:int,firstStrip:Boolean):ByteArray
	{
		//trace("CCITTG3Image::DecodeImageStrip( strip, " +maxLines+" )");
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
			
			//跳过第一个eol
			for (i=0,j=0;bytesArray[i]==0; i++) {}
			j=i;


			if (hiloBitOrder) {
				var b:int= Converter.reverseByte(ByteUtil.toSign(bytesArray[j]));
				for (i=0; (b>>i) != 1;i++) {}
			}
			else {
				for (i=0; (ByteUtil.toSign(bytesArray[j])>>i) != 1;i++) {}
			}
			i += j*8;
		}
		else {
			i=0;
		}

		//遍历数据
		for (lines=1,count=bytesArray.length*8; lines<maxLines && i<count; ) {

			//i 是位索引值, j 是字节索引值, shift 是在字节j中的偏移量
			j = i/8;
			shift = (i%8);

			//得到下一组字节
			b1=ByteUtil.toSign(bytesArray[j]);
			b2=(j+1<bytesArray.length ? ByteUtil.toSign(bytesArray[j+1]) : 0);
			b3=(j+2<bytesArray.length ? ByteUtil.toSign(bytesArray[j+2]) : 0);
			//如要有需要，移动字节偏移量
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
			//跟据表中数据找到值
			if (whiteRun) node=WhiteTree.Find(Converter.bytesToInt(tmp));
			else 	node=BlackTree.Find(Converter.bytesToInt(tmp));
			
			if (node != null)
				code = node.code;
				
			//跟据所得code的运行长度生成图片字节数组
				if (code.runLength>0) {
					ByteUtil.arraycopy( (whiteRun ? WhiteRun : BlackRun), 0, rawImage, nPixels, code.runLength*4 );
					nPixels += code.runLength*4;
				}

			//增加位索引值
			i += code.bitLength;

			//如果是EOL(end of the line), 增加行数（第一行以EOL开始，已经被跳过）
			if (code.runLength==T4Code.EOF) {
				lines --;
				break; 
			}

			//如果读取到EOL(end of the line)
			if (nPixels > 0&& code.runLength==T4Code.EOL ) //一行的结束
				{
				whiteRun = true; //总是以白色开始
				lines++;
				
				}
			else if (code.runLength<64) //如果是终结码
				whiteRun = !whiteRun;	//转换运行方式 (white/black)

		}

		bitsPerSample=8;
		return (rawImage);
	}

}
}
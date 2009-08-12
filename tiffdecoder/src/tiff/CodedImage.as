package tiff
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	

public class CodedImage {

	private var _imageBytes:ByteArray;
	public var imageStrips:Array;
	public var compType:Number;
	public var bitsPerSample:int, samplesPerPixel:int, extraSamples:int, photometric:int;
	public var imageWidth:int, imageHeight:int;

	internal var ifd:IFD;

	public function CodedImage(ifd:IFD) {
		this.ifd = ifd;

		imageBytes = null;
		imageStrips = null;
		compType = CompressionType.NONE;
		imageWidth =0;
		imageHeight =0;
		bitsPerSample=0;
		//samplesPerPixel=0;
		samplesPerPixel=1;
		extraSamples=-1;
		photometric=0;

//		short	redcmap[];			/* colormap pallete */
//		short	greencmap[];
//		short	bluecmap[];


//		TIFFRGBValue* Map;			/* sample mapping array */
//		uint32** BWmap;				/* black&white map */
//		uint32** PALmap;			/* palette image map */
//		TIFFYCbCrToRGB* ycbcr;			/* YCbCr conversion state */

		for (var i:int=0; i<ifd.count; i++) {

			if (ifd.entries[i].tag.equals(Tag.IMAGEWIDTH)) {
				imageWidth = int(ifd.entries[i].value);
			}
			else if (ifd.entries[i].tag.equals(Tag.IMAGELENGTH)) {
				imageHeight = int(ifd.entries[i].value);
			}
			else if (ifd.entries[i].tag.equals(Tag.COMPRESSION)) {
				compType = ifd.entries[i].value;
			}
			else if (ifd.entries[i].tag.equals(Tag.BITSPERSAMPLE)) {
				if (ifd.entries[i].isOffset()) {
					if (ifd.entries[i].type.isShort())
						bitsPerSample = ((ifd.entries[i].dataArray[0]&0xff)<<8) + (ifd.entries[i].dataArray[1]&0xff);
					else
						bitsPerSample = ((ifd.entries[i].dataArray[0]&0xff)<<24) + ((ifd.entries[i].dataArray[1]&0xff)<<16) + ((ifd.entries[i].dataArray[2]&0xff)<<8) + (ifd.entries[i].dataArray[3]&0xff);
				}
				else
					bitsPerSample = int(ifd.entries[i].value);
			}
			else if (ifd.entries[i].tag.equals(Tag.SAMPLESPERPIXEL)) {
				samplesPerPixel = int(ifd.entries[i].value);
			}
			else if (ifd.entries[i].tag.equals(Tag.EXTRASAMPLES)) {
				extraSamples = int(ifd.entries[i].value);
			}
			else if (ifd.entries[i].tag.equals(Tag.PHOTOMETRIC)) {
				photometric = int(ifd.entries[i].value);
			}
		}
	}

	public function isRaw():Boolean{
		return (compType == CompressionType.NONE);
	}

	public function isJPEG():Boolean{
		return (compType == CompressionType.JPEG || compType == CompressionType.OJPEG);
	}

	public function isCCITT():Boolean{
    return (compType == CompressionType.CCITTFAX3 ||
				    compType == CompressionType.CCITTFAX4 ||
				    compType == CompressionType.CCITTRLE ||
				    compType == CompressionType.CCITTRLEW);
	}


	/* function makeColorModel():ColorModel{
		var rLUT:Array, gLUT,bLUT;

		rLUT = new byte[256];
		gLUT = new byte[256];
		bLUT = new byte[256];
		for(var i:int=0; i<256; i++) {
			rLUT[i]=byte((i & 0xff));
			gLUT[i]=byte((i & 0xff));
			bLUT[i]=byte((i & 0xff));
		}
		return(new IndexColorModel(8, 256, rLUT, gLUT, bLUT));
	} */


	/* function makeRGBColorModel():ColorModel{
		var rLUT:Array, gLUT,bLUT;
		var map:Array= ifd.GetEntry( Tag.COLORMAP ).dataArray;
		var i:int, j, n = map.length/6; //2bytes (1 ignored) * 3
		var r:int= 0;
		var g:int= n*2;
		var b:int= n*4;
		System.out.println( "\nn="+n+", r="+r+", g="+g+", b="+b+"\n");
		rLUT = new byte[256];
		gLUT = new byte[256];
		bLUT = new byte[256];

		for(i=0, j=0; i<n; i++, j+=2) {
			rLUT[i]=byte((map[j+r] & 0xff));
			gLUT[i]=byte((map[j+g] & 0xff));
			bLUT[i]=byte((map[j+b] & 0xff));
		}

		for(i=n; i<256; i++) {
			rLUT[i]=0;
			gLUT[i]=0;
			bLUT[i]=0;
		}


		return(new IndexColorModel(bitsPerSample, n, rLUT, gLUT, bLUT));
	} */

 /*
 	* Macros for extracting components from the
 	* packed ABGR form returned by TIFFReadRGBAImage.
 	*/
	public function GetR( abgr:int):int{	return (abgr& 0xff); }
	public function GetG( abgr:int):int{	return ((abgr>> 8) & 0xff); }
	public function GetB( abgr:int):int{	return ((abgr>> 16) & 0xff); }
	public function GetA( abgr:int):int{	return ((abgr>> 24) & 0xff); }


	public function getImage():BitmapData{
		return null;
	} 


	/* public function getImageProducer():Object{

		var cm:ColorModel= makeColorModel();
		var pixels:Array;
 	  imageWidth =256;
 	  imageHeight=256;

    pixels = new int[imageWidth * imageHeight];
		for (var y:int=0; y<pixels.length; y+=imageWidth) {
			for (var x:int=0; x<imageWidth; x++) {
				pixels[x + y] = (x&0xff);
			}
		}

		return new MemoryImageSource(imageWidth, imageHeight, pixels, 0, imageWidth);
	} */

	/*
 * Construct any mapping table used
 * by the associated put routine.
 */

	/*
	 * Check the image to see if TIFFReadRGBAImage can deal with it.
	 * 1/0 is returned according to whether or not the image can
	 * be handled.  If 0 is returned, emsg contains the reason
	 * why it is being rejected.
	 */
	/* function CanDecodeImage():Boolean{
		var emsg:String;
	  var colorChannels:int;
	  var planarConfig:int;

	  switch (bitsPerSample) {
	    case 1: case 2: case 4: case 8: case 16: break;
	    default:
				emsg = "Sorry, can not handle images with " +bitsPerSample+"-bit samples";
				trace(emsg);
				return (false);
	  }

	  if (extraSamples==-1) //tag not set in IFD
	  	colorChannels = samplesPerPixel; //normally would default to 0
	  else
	  	colorChannels = samplesPerPixel - extraSamples;

	  trace("samplesPerPixel:"+samplesPerPixel+
	  					 ", extraSamples:"+extraSamples+
	  					 ", colorChannels:"+colorChannels+
	  					 ", photometric:"+photometric);

	  if (photometric==0&& extraSamples!=-1) {
			switch (colorChannels) {
				case 1:	photometric = PhotometricType.MINISBLACK;   	break;
				case 3: photometric = PhotometricType.RGB;	    			break;
				default:
		    	emsg = "Missing needed PHOTOMETRIC tag";
					trace(emsg);
		    	return (false);
			}
	  }



	  switch (photometric) {
	    case PhotometricType.MINISWHITE:
	    case PhotometricType.MINISBLACK:
	    case PhotometricType.PALETTE:
			  planarConfig = ifd.GetFieldValue(Tag.PLANARCONFIG);
				if (planarConfig == PlanarConfigType.CONTIG && samplesPerPixel != 1) {
		    	emsg = "Sorry, can not handle contiguous data with PHOTOMETRIC="+photometric+", and Samples per Pixel=" + samplesPerPixel;
					System.out.println(emsg);
		  	  return (false);
				}
				break;
	    case PhotometricType.YCBCR:
			  planarConfig = ifd.GetFieldValue(Tag.PLANARCONFIG);
				if (planarConfig != PlanarConfigType.CONTIG) {
		    	emsg = "Sorry, can not handle YCbCr images with Planarconfiguration="+ planarConfig;
					trace(emsg);
			    return (false);
				}
				break;
	    case PhotometricType.RGB:
				if (colorChannels < 3) {
		    	emsg="Sorry, can not handle RGB image with Color channels="+ colorChannels;
					trace(emsg);
		    	return (false);
				}
				break;
	    default:
				emsg= "Sorry, can not handle image with Photometric="+photometric;
				trace(emsg);
				return (false);
	  }
	  return (true);
	}  */
	public function set imageBytes(value:ByteArray):void{
		
		_imageBytes=value;
	
	}
	public function get imageBytes():ByteArray{
		
		return _imageBytes;
	
	}

}
}
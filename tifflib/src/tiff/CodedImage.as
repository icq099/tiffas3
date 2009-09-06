package tiff
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 *抽象tiff图像的基类
	 * @author Administrator
	 * 
	 */	
public class CodedImage {

	private var _imageBytes:ByteArray;
	protected var img:BitmapData;
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
	
	public function GetR( abgr:int):int{	return (abgr& 0xff); }
	public function GetG( abgr:int):int{	return ((abgr>> 8) & 0xff); }
	public function GetB( abgr:int):int{	return ((abgr>> 16) & 0xff); }
	public function GetA( abgr:int):int{	return ((abgr>> 24) & 0xff); }


	public function getImage():BitmapData{
		return null;
	} 
	
	public function set imageBytes(value:ByteArray):void{
		
		_imageBytes=value;
	
	}
	public function get imageBytes():ByteArray{
		
		return _imageBytes;
	
	}

}
}
package tiff
{
	/**
	 *抽象tiff图像的基类之一，保留以便扩展 
	 * @author yzhkof
	 * 
	 */	
	public class RawImage extends CodedImage
	{
		public function RawImage(ifd:IFD)
		{
			super(ifd);
		}

	}
}
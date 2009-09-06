package tiff
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * 这个是tiff的主类
	 * 将传入的以g3t4方式压缩的tiff图片的byteArray解析为as3可识别的bitmapdata对象，请不要传入g3t4以外方式编码的tiff图片。
	 * @author yzhkof
	 * 
	 */		
	public class Tiff
	{
		private var header:Header;
		private var pages:Array;//type IDF
		private var pageCount:int;
		
		public function Tiff()
		{
			
			header=new Header();
			pages=null;
			pageCount=0;
			
		}
		/**
		 *得到tiff文件分页总数 
		 * @return 
		 * 
		 */		
		public function getPageCount():int{
			
			return pageCount;
		
		}
		/**
		 *得到指定tiff分页的bitmapdata对象。调用此方法将进行该分页的解码工作。
		 * @param page
		 * @return 
		 * 
		 */		
		public function getImage(page:int):BitmapData{
			
			if (pageCount==0 || page > pageCount) return null;
			return pages[page].getImage();
		
		}
		/**
		 *传入装载tiff数据的byteArray，并进行基本属性的分析。
		 * @param bytesArray
		 * 
		 */	
		public function read(bytesArray:ByteArray):void{
			
			var inb:ByteArray=bytesArray;
			pageCount=0;
			pages=new Array();
			header.read(inb);
			var offset:uint=header.offset;
			
			while(offset!=0){
				
				inb.position=offset;
				pages.push(new IFD());
				IFD(pages[pageCount]).read(inb);
				
				offset=IFD(pages[pageCount]).offset;
				pageCount++;
			
			}			
		}

	}
}
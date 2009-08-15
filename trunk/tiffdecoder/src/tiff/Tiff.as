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
		/* public function getImageProducer(page:int):Object{
			
			if (pageCount==0 || page > pageCount) return null;
			return pages[page].getImageProducer();
		
		} */
		/* public function readInputStream(input:ByteArray):void{
			
			var CHUNK:int = 10240;
			var i:int,count:int,max:int=10 * CHUNK;
			var tmp:ByteArray=new ByteArray(),bytesArray:ByteArray=new ByteArray();
			
			for (i=0,count=0; (count = input[tmp]) != -1; i+=count){
				
				if (i+count > max) {
					var ba:ByteArray = new ByteArray;
		    		//System.arraycopy( bytesArray, 0, ba, 0, i );
		    		max = i + count + CHUNK;
		    		bytesArray = ba;
				}
			}
		
		}	 */	
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
				if (pageCount>=10 && offset!=0) {
					trace("Oop, I was cheating and only allowed for 10 pages in a tif file");
					break; 
				}
			
			}			
		}

	}
}
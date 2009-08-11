package tiff
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
		
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
		public function getPageCount():int{
			
			return pageCount;
		
		}
		public function getImage(page:int):BitmapData{
			
			if (pageCount==0 || page > pageCount) return null;
			return pages[page].getImage();
		
		}
		public function getImageProducer(page:int):Object{
			
			if (pageCount==0 || page > pageCount) return null;
			return pages[page].getImageProducer();
		
		}
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
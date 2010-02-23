package lxfa.index.view
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	
	public class FLVPlayer extends Sprite
	{
		private var  bulkLoader:BulkLoader;
		private var netStream:NetStream;
		private var video:Video;
		public function FLVPlayer()
		{
			initBulkLoader();
		}
		private function initBulkLoader():void
		{
			bulkLoader=new BulkLoader("video/index/index.flv");
			bulkLoader.add("video/index/index.flv");
			bulkLoader.start();
			bulkLoader.addEventListener(BulkProgressEvent.PROGRESS,progressHandler);
			bulkLoader.addEventListener(BulkProgressEvent.COMPLETE,completeHandler);
		}
		private function progressHandler(e:BulkProgressEvent):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		public function pause():void
		{
			netStream.pause();
		}
		public function resume():void
		{
			netStream.resume();
		}
		private function completeHandler(e:BulkProgressEvent):void
		{
			netStream=NetStream(bulkLoader.getContent("video/index/index.flv"));
			netStream.pause();
			video=new Video(900,600);
			video.attachNetStream(netStream);
			this.addChild(video);
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,e.bytesLoaded,e.bytesTotal));
		}
		public function dispose():void
		{
			netStream.close();
			bulkLoader.clear();
			video=null;
			netStream=null;
			bulkLoader=null
		}
	}
}

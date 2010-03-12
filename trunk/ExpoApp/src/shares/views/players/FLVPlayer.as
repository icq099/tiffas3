package shares.views.players
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class FLVPlayer extends Sprite
	{
		
		private var netStream:NetStream;
		private var netConnection:NetConnection;
		private var video:Video;
		private var path:String;
		private var loader:Loader;
		private var videoWidth:int;
		private var videoHeight:int;
		public function FLVPlayer(path:String,width:int,height:int)
		{
			this.path=path;
			this.videoWidth=width;
			this.videoHeight=height;
			initNetConnection();
		}
		private function initNetConnection():void
		{
			netConnection=new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS,netConnection_NetStatus_handler);
			netConnection.connect(null);//这句话一定要在事件之后
		}
		private function netConnection_NetStatus_handler(e:NetStatusEvent):void
		{
			if(e.info.code=="NetConnection.Connect.Success")
			{
				netStream=new NetStream(netConnection);
				netStream.client=new Object();
				video=new Video(this.videoWidth,this.videoHeight);
				video.attachNetStream(netStream);
				this.addChild(video);
				netStream.play(this.path);
				netStream.pause();
				netStream.addEventListener(NetStatusEvent.NET_STATUS,netStream_NetStatusHandler);
				this.addEventListener(Event.ENTER_FRAME,on_ENTER_FRAME);
				initBTNClose();
			}
		}
		private function netStream_NetStatusHandler(e:NetStatusEvent):void
		{
			if(e.info.code=="NetStream.Play.Stop")
			{
				this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS));
			}
		}
		//对外抛出进度事件
		private function on_ENTER_FRAME(e:Event):void
		{
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,netStream.bytesLoaded,netStream.bytesTotal));
			if(netStream.bytesLoaded==netStream.bytesTotal)
			{
				this.removeEventListener(Event.ENTER_FRAME,on_ENTER_FRAME);//不再对外抛出进度事件
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		public function pause():void
		{
			netStream.pause();
		}
		public function resume():void
		{
			if(netStream!=null)
			{
				netStream.resume();
			}else
			{
//				this.addEventListener(Event.EXIT_FRAME,onEXIT_FRAME);
			}
		}
//		private function onEXIT_FRAME(e:Event):void
//		{
//			if(netStream!=null)
//			{
//				netStream.resume();
//			}
//		}
		//初始化关闭按钮
		private function initBTNClose():void
		{
			var close:BTNClose=new BTNClose();
			close.addEventListener(MouseEvent.CLICK,on_close_click);
			close.y=10;
			close.x=850;
			this.addChild(close);
		}
		//关闭按钮的点击事件
		private function on_close_click(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		public function dispose():void
		{
			netStream.close();
			video=null;
			netStream=null;
		}
	}
}

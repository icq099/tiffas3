package lxfa.view.player
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import lxfa.utils.MemoryRecovery;
	
	public class FLVPlayer extends Sprite
	{
		
		private var netStream:NetStream;
		private var netConnection:NetConnection;
		private var video:Video;
		private var path:String;
		private var videoWidth:int;
		private var videoHeight:int;
		private var hasCloseButton:Boolean;
		public function FLVPlayer(path:String,width:int,height:int,hasCloseButton:Boolean=true)
		{
			this.path=path;
			this.videoWidth=width;
			this.videoHeight=height;
			this.hasCloseButton=hasCloseButton;
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
			}
		}
		//重新播放
		public function restart():void{
			if(netStream!=null)
			{
				netStream.seek(0);
				resume();
			}
		}
		private function netStream_NetStatusHandler(e:NetStatusEvent):void
		{
			if(e.info.code=="NetStream.Play.Stop")
			{
				this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS));
			}
		}
		private var hasPushReadyEvent:Boolean=false;
		//对外抛出进度事件
		private function on_ENTER_FRAME(e:Event):void
		{
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,netStream.bytesLoaded,netStream.bytesTotal));
			if(netStream.bytesLoaded==netStream.bytesTotal)
			{
				this.removeEventListener(Event.ENTER_FRAME,on_ENTER_FRAME);//不再对外抛出进度事件
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			if(!hasPushReadyEvent)
			{
				if(netStream.bytesLoaded/netStream.bytesTotal>0.01)
				{
					hasPushReadyEvent=true;
					this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.READY));
					if(hasCloseButton)
					{
						initBTNClose();
					}
				}
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
				this.addEventListener(Event.EXIT_FRAME,onEXIT_FRAME);
			}
		}
		private function onEXIT_FRAME(e:Event):void
		{
			if(netStream!=null)
			{
				netStream.resume();
			}
		}
		private var close:BTNClose;
		//初始化关闭按钮
		private function initBTNClose():void
		{
			close=new BTNClose();
			close.addEventListener(MouseEvent.CLICK,on_close_click);
			close.y=10;
			close.x=780;
			close.buttonMode=true;
			this.addChild(close);
		}
		//关闭按钮的点击事件
		private function on_close_click(e:MouseEvent):void
		{
			close.mouseEnabled=false;
			netStream.pause();
			this.dispatchEvent(new Event(Event.CLOSE));
			MemoryRecovery.getInstance().gcFun(close,MouseEvent.CLICK,on_close_click);
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcObj(close);
			if(netStream!=null)
			{
				netStream.pause();	
			}
			this.removeEventListener(Event.ENTER_FRAME,on_ENTER_FRAME);//不再对外抛出进度事件
			video=null;
			netStream=null;
		}
	}
}

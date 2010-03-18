package lxfa.flvModule
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;
	
	public class FlvBase extends UIComponent
	{
		private var flvPlayer:FLVPlayer;
		public function FlvBase()
		{
			MainSystem.getInstance().addAPI("addFlv",initPlayer);
			MainSystem.getInstance().addAPI("removeFlv",dispose);
		}
		public function initPlayer(url:String,hasCloseButton:Boolean=true):void
		{
			flvPlayer=new FLVPlayer(url,900,480,hasCloseButton);
			this.addChild(flvPlayer);
			flvPlayer.y=70;
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_play_complete);
			flvPlayer.addEventListener(Event.CLOSE,onClose);
			flvPlayer.addEventListener(ProgressEvent.PROGRESS,PROGRESS_refresh);
			flvPlayer.addEventListener(Event.COMPLETE,on_complete);
		}
		private function on_complete(e:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function PROGRESS_refresh(e:ProgressEvent):void
		{
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,e.bytesLoaded,e.bytesTotal));
		}
		private function on_play_complete(e:NetStatusEvent):void
		{
			this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS));
		}
		private function onClose(e:Event):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
			flvPlayer.removeEventListener(Event.CLOSE,onClose);
			flvPlayer.removeEventListener(NetStatusEvent.NET_STATUS,on_play_complete);
		}
		public function dispose():void
		{
			if(flvPlayer!=null)
			{
				flvPlayer.pause();
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			}
		}
	}
}
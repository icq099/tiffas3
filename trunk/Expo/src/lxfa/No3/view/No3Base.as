package lxfa.No3.view
{
	import communication.Event.MainSystemEvent;
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lxfa.view.player.FLVPlayer;
	
	public class No3Base extends Sprite
	{
		private var flvPlayer:FLVPlayer;
		private var isClosed:Boolean=false;
		public function No3Base()
		{
			super();
			MainSystem.getInstance().isBusy=true;
			initFLVPlayer();
		}
		private function initFLVPlayer():void
		{
			if(!isClosed)
			{
				flvPlayer=new FLVPlayer("video/no3/no3.flv",900,480);
				flvPlayer.y=70;
				this.addChild(flvPlayer);
				flvPlayer.addEventListener(Event.COMPLETE,on_flv_complete);
				flvPlayer.resume();
			}
		}
		private function on_flv_complete(e:Event):void//FLV加载完毕
		{
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().removePluginById("IndexModule");
			MainSystem.getInstance().runAPIDirect("addAnimate",[0]);
			flvPlayer.addEventListener(Event.CLOSE,on_flvPlayer_close);
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,flvPlayer_NetStatus_handler);
		}
		private function flvPlayer_NetStatus_handler(e:Event):void
		{
 			step4();
		}
		private function on_flvPlayer_close(e:Event):void
		{
			step4();
		}
		public function step4():void
		{
            MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
            MainSystem.getInstance().showPluginById("No3SwfModule");
            MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
            MainSystem.getInstance().addEventListener(MainSystemEvent.ON_PLUGIN_READY,on_plugin_ready);
		}
		private function on_plugin_ready(e:MainSystemEvent):void
		{
			if(e.id=="No3SwfModule")
			{
				MainSystem.getInstance().removePluginById("No3Module");
			}
		}
		public function dispose():void
		{
			if(!isClosed)
			{
				isClosed=true;
				if(flvPlayer!=null)
				{
					this.removeChild(flvPlayer);
					flvPlayer.dispose();
					flvPlayer=null;
				}
			}
		}
	}
}
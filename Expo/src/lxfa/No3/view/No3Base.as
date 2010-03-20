package lxfa.No3.view
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.view.player.FLVPlayer;
	
	public class No3Base extends Sprite
	{
		private var flvPlayer:FLVPlayer;
		private var isClosed:Boolean=false;
		public function No3Base()
		{
			super();
			initFLVPlayer();
			initAnimation();
		}
		private function initAnimation():void
		{
			MainSystem.getInstance().runAPIDirect("addAnimate",[0]);
		}
		private function initFLVPlayer():void
		{
			if(!isClosed)
			{
				flvPlayer=new FLVPlayer("video/no3/no3.flv",900,480);
				flvPlayer.y=70;
				flvPlayer.addEventListener(Event.CLOSE,on_flvPlayer_close);
				this.addChild(flvPlayer);
				flvPlayer.resume();
				flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,flvPlayer_NetStatus_handler);
			}
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
			MainSystem.getInstance().removePluginById("No3Module");
            MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
            MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
            MainSystem.getInstance().showPluginById("No3SwfModule");
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
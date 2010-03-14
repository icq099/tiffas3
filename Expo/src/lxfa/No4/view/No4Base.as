package lxfa.No4.view
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	
	import lxfa.view.player.FLVPlayer;
	
	public class No4Base extends Sprite
	{
		private var flvPlayer:FLVPlayer;
		public function No4Base()
		{
			initFLVPlayer();
		}
		//初始化播放器
		private function initFLVPlayer():void
		{
			flvPlayer=new FLVPlayer("video/no4/no4.flv",900,600);
			this.addChild(flvPlayer);
			flvPlayer.resume();
			MainSystem.getInstance().showPluginById("No5Module");
			MainSystem.getInstance().gotoScene(0);//跑到绿色家园
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,flvPlayer_NetStatusHandler);
		}
		private function flvPlayer_NetStatusHandler(e:NetStatusEvent):void
		{
			MainSystem.getInstance().enable360System();
			MainSystem.getInstance().removePluginById("No4Module");
			MainSystem.getInstance().showPluginById("AnimationModule");
			MainSystem.getInstance().runAPIDirect("showGuiWa",[1]);
		}
		public function dispose():void
		{
			flvPlayer.dispose();
			flvPlayer=null;
		}
	}
}
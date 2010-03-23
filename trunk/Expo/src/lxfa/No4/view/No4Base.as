package lxfa.No4.view
{
	import communication.Event.PluginEvent;
	import communication.Event.SceneChangeEvent;
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
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
			MainSystem.getInstance().isBusy=true;
			flvPlayer=new FLVPlayer("video/no4/no4.flv",900,480,false);
			flvPlayer.y=70;
			this.addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE,on_flv_ready);
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,flvPlayer_NetStatusHandler);
		}
		private function on_flv_ready(e:FLVPlayerEvent):void
		{
			flvPlayer.resume();
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			MainSystem.getInstance().isBusy=true;
		}
		private function flvPlayer_NetStatusHandler(e:NetStatusEvent):void
		{
			MainSystem.getInstance().isBusy=false;
			if(!MainSystem.getInstance().is360Ready)
			{
				MainSystem.getInstance().enable360System();
			}
			MainSystem.getInstance().gotoScene(0);//跑到绿色家园
			MainSystem.getInstance().addEventListener(SceneChangeEvent.CHANGED,on_scenechanged);
		}
		private function on_scenechanged(e:SceneChangeEvent):void
		{
			MainSystem.getInstance().startRender();
			dispose();
		}
		public function dispose():void
		{
			if(flvPlayer!=null)
			{
				flvPlayer.visible=false;
				flvPlayer.dispose();
				if(flvPlayer.parent!=null)
				{
					flvPlayer.parent.removeChild(flvPlayer);
				}
	//			flvPlayer.dispose();
//				flvPlayer=null;
//				MainSystem.getInstance().removePluginById("No4Module");
			}
		}
	}
}
package lxfa.No4.view
{
	import communication.Event.SceneChangeEvent;
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.Application;
	
	import yzhkof.Toolyzhkof;
	
	
	public class No4Base extends Sprite
	{
		private var flvPlayer:FLVPlayer;
		private var loading_mc:LoadingWaveRota;
		public function No4Base()
		{
			initLoadingMc();
			initFLVPlayer();
		}
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			this.addEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
		}
		private function on_added_to_stage(e:Event):void
		{
			loading_mc.x=this.stage.stageWidth/2;
			loading_mc.y=this.stage.stageHeight/2;
			Application.application.addChild(Toolyzhkof.mcToUI(loading_mc));
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
			flvPlayer.addEventListener(ProgressEvent.PROGRESS,on_progress_change);
		}
		private function on_progress_change(e:ProgressEvent):void
		{
			loading_mc.updateByProgressEvent(e);
		}
		private function on_flv_ready(e:FLVPlayerEvent):void
		{
			MemoryRecovery.getInstance().gcFun(flvPlayer,ProgressEvent.PROGRESS,on_progress_change);
			MemoryRecovery.getInstance().gcObj(loading_mc);
			MemoryRecovery.getInstance().gcFun(flvPlayer,FLVPlayerEvent.COMPLETE,on_flv_ready);
			flvPlayer.resume();
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatcherSceneChangeComplete(4);
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
			MainSystem.getInstance().addEventListener(SceneChangeEvent.COMPLETE,on_scenechanged);
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
			}
		}
	}
}
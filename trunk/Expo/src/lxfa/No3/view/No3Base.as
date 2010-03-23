package lxfa.No3.view
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.Application;
	
	import yzhkof.Toolyzhkof;
	import yzhkof.loadings.LoadingWaveRota;
	
	public class No3Base extends Sprite
	{
		private var flvPlayer:FLVPlayer;
		private var isClosed:Boolean=false;
		private var loading_mc:LoadingWaveRota;
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
				initLoadingMc();
				flvPlayer=new FLVPlayer("video/no3/no3.flv",900,480);
				flvPlayer.y=70;
				this.addChild(flvPlayer);
				flvPlayer.addEventListener(ProgressEvent.PROGRESS,on_flv_progress);
				flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE,on_flv_complete);
			}
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
		private function on_flv_progress(e:ProgressEvent):void//FLV加载完毕
		{
			loading_mc.updateByProgressEvent(e);
		}
		private function on_flv_complete(e:FLVPlayerEvent):void
		{
			flvPlayer.resume();
			MemoryRecovery.getInstance().gcObj(loading_mc);
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
            MainSystem.getInstance().showPluginById("No3SwfModule");
            MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcObj(loading_mc);
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
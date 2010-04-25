package plugins.lxfa.No3.view
{
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.pluginManager.event.PluginEvent;
	import core.manager.sceneManager.SceneManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import memory.MemoryRecovery;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import util.view.player.FLVPlayer;
	import util.view.player.event.FLVPlayerEvent;
	
	import view.loadings.LoadingWaveRota;
	public class No3Base extends UIComponent
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
				flvPlayer=new FLVPlayer("http://flv.pavilion.expo.cn/p5006/flv/scene_scene/no3.flv",900,480);
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
			Application.application.addChildAt(loading_mc,Application.application.numChildren-1);
		}
		private function on_flv_progress(e:ProgressEvent):void//FLV加载完毕
		{
			loading_mc.updateByProgressEvent(e);
		}
		private function on_flv_complete(e:FLVPlayerEvent):void
		{
			flvPlayer.resume();
			if(loading_mc!=null)
			{
				if(loading_mc.parent!=null)
				{
					loading_mc.parent.removeChild(loading_mc);
				}
				loading_mc=null;
			}
			MainSystem.getInstance().isBusy=false;
			PluginManager.getInstance().removePluginById("IndexModule");
			ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[0]);
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
            PluginManager.getInstance().showPluginById("No3SwfModule");
            SceneManager.getInstance().dispacherSceneChangeInitEvent(-1);
		}
		public function dispose():void
		{
			if(loading_mc!=null)
			{
				if(loading_mc.parent!=null)
				{
					loading_mc.parent.removeChild(loading_mc);
				}
				loading_mc=null;
			}
			MemoryRecovery.getInstance().gcFun(flvPlayer,Event.CLOSE,on_flvPlayer_close);
			MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS,flvPlayer_NetStatus_handler);
			MemoryRecovery.getInstance().gcFun(flvPlayer,ProgressEvent.PROGRESS,on_flv_progress);
			MemoryRecovery.getInstance().gcFun(flvPlayer,FLVPlayerEvent.COMPLETE,on_flv_complete);
			MemoryRecovery.getInstance().gcFun(this,Event.ADDED_TO_STAGE,on_added_to_stage);
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
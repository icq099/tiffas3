package plugins.lsd.swfModule
{
	import core.manager.MainSystem;
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.sceneManager.SceneManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import memory.MemoryRecovery;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import view.loadings.LoadingWaveRota;
	import view.player.SwfPlayer;
	
	public class SwfModuleBase extends UIComponent
	{
		private var loading_mc:LoadingWaveRota;           //显示加载的进度
		private var swfPlayer:SwfPlayer;                  //SWF播放器
		private var initScript:String="";                 //SWF载入的时候要执行的脚本
		private var completeScript:String="";             //SWF加载完毕的时候要执行的脚本
		public function SwfModuleBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.ADD_SWF_INIT_SCRIPT,addInitScript);
			ScriptManager.getInstance().addApi(ScriptName.ADD_SWF_COMPLETE_SCRIPT,addCompleteScript);
			ScriptManager.getInstance().addApi(ScriptName.SHOW_SWF,showSwf);
		}
		//添加swf刚开始载入的时的脚本
		private function addInitScript(script:String):void
		{
			initScript+=script;
		}
		//添加SWF载入完毕时的脚本
		private function addCompleteScript(script:String):void
		{
			completeScript+=script;
		}
		//显示SWF
		private function showSwf(path:String):void
		{
			dispose(null);
			ScriptManager.getInstance().runScriptDirectly(initScript);
			swfPlayer=new SwfPlayer(path,900,480);
			initLoadingMc();
			swfPlayer.addEventListener(ProgressEvent.PROGRESS, on_swf_progress);
			swfPlayer.addEventListener(Event.COMPLETE, on_swf_complete);
		}
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			loading_mc.x=Application.application.width/2;
			loading_mc.y=Application.application.height/2;
			Application.application.addChild(loading_mc);
		}
		private function on_swf_progress(e:ProgressEvent):void
		{
			loading_mc.updateByProgressEvent(e);
		}
		private function on_swf_complete(e:Event):void
		{
			if(loading_mc!=null)
			{
				if(loading_mc.parent!=null)
				{
					loading_mc.parent.removeChild(loading_mc);
				}
				loading_mc=null;
			}
			this.addChild(swfPlayer);
			SceneManager.getInstance().dispacherJustBeforeCompleteEvent(SceneManager.getInstance().currentSceneId);
			SceneManager.getInstance().addEventListener(SceneChangeEvent.COMPLETE,dispose);
			SceneManager.getInstance().addEventListener(SceneChangeEvent.INIT,otherSceneInit);
			MainSystem.getInstance().isBusy=false;
			ScriptManager.getInstance().runScriptDirectly(completeScript);
		}
		private function otherSceneInit(e:SceneChangeEvent):void
		{
			if(swfPlayer!=null)
			{
				swfPlayer.mouseEnabled=false;
				swfPlayer.enabled=false;
			}
		}
		private function dispose(e:SceneChangeEvent):void
		{
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.INIT,otherSceneInit);
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.COMPLETE,dispose);
			MemoryRecovery.getInstance().gcFun(swfPlayer,ProgressEvent.PROGRESS, on_swf_progress);
			MemoryRecovery.getInstance().gcFun(swfPlayer,Event.COMPLETE, on_swf_complete);
			if(loading_mc!=null)
			{
				if(loading_mc.parent!=null)
				{
					loading_mc.parent.removeChild(loading_mc);
				}
				loading_mc=null;
			}
			if(swfPlayer!=null)
			{
				swfPlayer.dispose();
				if(swfPlayer.parent!=null)
				{
					swfPlayer.parent.removeChild(swfPlayer);
				}
				swfPlayer=null;
			}
			initScript="";
			completeScript="";
		}
	}
}
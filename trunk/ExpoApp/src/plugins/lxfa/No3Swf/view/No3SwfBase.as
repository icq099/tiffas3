package plugins.lxfa.No3Swf.view
{
	import core.manager.MainSystem;
	import core.manager.musicManager.BackGroundMusicManager;
	import core.manager.pluginManager.PluginManager;
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.sceneManager.SceneManager;
	
	import flash.events.ProgressEvent;
	
	import memory.MemoryRecovery;
	import memory.MyGC;
	
	import mx.controls.SWFLoader;
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import util.loaders.SerialSwfLoader;
	import util.loaders.SerialSwfLoaderEvent;
	
	import view.ToolTip;
	import view.loadings.LoadingWaveRota;
	public class No3SwfBase extends UIComponent
	{
		private var serialSwfLoader:SerialSwfLoader;
		private var loading_mc:LoadingWaveRota;//用于显示进度
		private var swf1:SWFLoader;
		private var swf2:SWFLoader;
		public function No3SwfBase()
		{
			MainSystem.getInstance().isBusy=true;
			initLoadingMc();//初始化LOADING_MC
			serialSwfLoader=new SerialSwfLoader();
			serialSwfLoader.add("id1","swf/no3Swf1.swf");
			serialSwfLoader.add("id2","swf/no3Swf2.swf");
			serialSwfLoader.addEventListener(SerialSwfLoaderEvent.ALL_COMPLETE,allComplete);
			serialSwfLoader.addEventListener(ProgressEvent.PROGRESS,on_progress);
			serialSwfLoader.start();
		}
		private function allComplete(e:SerialSwfLoaderEvent):void
		{
			MemoryRecovery.getInstance().gcFun(serialSwfLoader,ProgressEvent.PROGRESS,on_progress);
			this.removeChild(loading_mc);
			loading_mc=null;
			ToolTip.init(Application.application.stage);
			swf1=serialSwfLoader.getValue("id1");
			swf1.x=-200;
			swf1.y=-100;
			swf1.width=900;
			swf1.height=480;
			swf1.maintainAspectRatio=false;//关键
			swf1.scaleContent=false;//关键
			swf2=serialSwfLoader.getValue("id2");
			swf2.x=-200;
			swf2.y=-100;
			swf2.width=900;
			swf2.height=480;
			swf2.maintainAspectRatio=false;//关键
			swf2.scaleContent=false;//关键
			this.addChild(serialSwfLoader.getValue("id1"));
			this.addChild(serialSwfLoader.getValue("id2"));
			MainSystem.getInstance().isBusy=false;
            MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
			BackGroundMusicManager.getInstance().loadBackGroundMusic("http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg1.mp3");
			SceneManager.getInstance().addEventListener(SceneChangeEvent.COMPLETE,removeCurrentModule);
			MainSystem.getInstance().removePluginById("No3Module");
			serialSwfLoader.dispose();
			serialSwfLoader=null;
		}
		private function on_progress(e:ProgressEvent):void
		{
			loading_mc.updateByProgressEvent(e);//更新显示的进度
		}
		//进度
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			this.addChild(loading_mc);//添加到Application，这样才可以覆盖插件
			loading_mc.x=Application.application.width/2-200;
			loading_mc.y=Application.application.height/2-170;
		}
		private function removeCurrentModule(e:SceneChangeEvent):void
		{
			 PluginManager.getInstance().removePluginById("No3SwfModule");
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.COMPLETE,removeCurrentModule);
			MemoryRecovery.getInstance().gcFun(serialSwfLoader,SerialSwfLoaderEvent.ALL_COMPLETE,allComplete);
			MemoryRecovery.getInstance().gcFun(serialSwfLoader,ProgressEvent.PROGRESS,on_progress);
			if(serialSwfLoader!=null)
			{
				serialSwfLoader.dispose();
			}
			serialSwfLoader=null;
			if(swf1!=null)
			{
				if(swf1.parent!=null)
				{
					swf1.unloadAndStop();
					swf1.parent.removeChild(swf1);
				}
				swf1=null;
			}
			if(swf2!=null)
			{
				if(swf2.parent!=null)
				{
					swf2.unloadAndStop();
					swf2.parent.removeChild(swf2);
				}
				swf2=null;
			}
			MyGC.gc();
		}
	}
}
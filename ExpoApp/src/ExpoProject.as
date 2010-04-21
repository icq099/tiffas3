package
{
	import core.manager.modelManager.ModelManager;
	import core.manager.pluginManager.PluginManager;
	import core.manager.sceneManager.SceneManager;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.core.Application;
	
	import view.loadings.LoadingWaveRota;
	
	public class ExpoProject 
	{
		public function ExpoProject()
		{
			init();
		}
		private var loadingMC:LoadingWaveRota;//显示数据加载的进度
		private function init():void
		{
			initModelManager();
		}
		private function initModelManager():void
		{
			//初始化数据库,要初始化加载进度，完成事件
			ModelManager.getInstance();
			loadingMC=new LoadingWaveRota();
			loadingMC.x=Application.application.width/2;
			loadingMC.y=Application.application.height/2;
			Application.application.addChild(loadingMC);
			ModelManager.getInstance().addEventListener(Event.COMPLETE,on_model_loaded);
			ModelManager.getInstance().addEventListener(ProgressEvent.PROGRESS,on_progress);
		}
		private function on_progress(e:ProgressEvent):void
		{
			loadingMC.updateByProgressEvent(e);
		}
		//全部数据库的数据加载完毕,开始加载插件
		private function on_model_loaded(e:Event):void
		{
			PluginManager.getInstance().init(Application.application);//初始化插件管理者，并且以Application.application为容器
			SceneManager.getInstance();                               //初始化场景管理者
			dispose();
			PluginManager.getInstance().showPluginById("GeHaiQingYunModule");
		}
		//回收内存
		private function dispose():void
		{
			ModelManager.getInstance().removeEventListener(ProgressEvent.PROGRESS,on_progress);
			ModelManager.getInstance().removeEventListener(Event.COMPLETE,on_model_loaded);
			loadingMC.parent.removeChild(loadingMC);
			loadingMC=null;
		}
	}
}
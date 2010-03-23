package lxfa.utils
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;
	import yzhkof.loadings.LoadingWaveRota;

	
	public class LoadingMcManager extends UIComponent
	{   
		public static var instance:LoadingMcManager;
		private var loading_mc:LoadingWaveRota;
		private var _obj:*;
		public function LoadingMcManager()
		{
			if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("不能实例化");
			}
		}
		public static function getInstance():LoadingMcManager
		{
			if(instance==null) return new LoadingMcManager();
			return instance;
		}
		
		public function loadingMcInit():void{
			
			loading_mc=new LoadingWaveRota();
			trace("A");
			Application.application.addEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
			
		}
		public function loadingMcListener(obj:*):void{
			
			this._obj=obj;
			_obj.addEventListener(ProgressEvent.PROGRESS,on_progress);
		}
		
		
		private function on_added_to_stage(e:Event):void
		{
			loading_mc.x=this.stage.stageWidth/2;
			loading_mc.y=this.stage.stageHeight/2;
			Application.application.addChild(Toolyzhkof.mcToUI(loading_mc));
		}
		private function on_progress(e:ProgressEvent):void//加载完毕
		{
			loading_mc.updateByProgressEvent(e);
		}
		public function dispose():void
		{
		
		  MemoryRecovery.getInstance().gcObj(loading_mc);
		  MemoryRecovery.getInstance().gcFun(_obj,ProgressEvent.PROGRESS,on_progress);
       }
	}
}
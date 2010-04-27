package plugins.lxfa.minzubaimei.view
{
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	
	import memory.MemoryRecovery;
	import memory.MyGC;
	
	import mx.core.UIComponent;
	
	import plugins.lsd.CustomWindow.CustomWindow;
	import plugins.lsd.CustomWindow.CustomWindowEvent;
	import plugins.model.ItemModel;
	
	public class MinZuBaiMei extends UIComponent
	{
		private var miniCarouselReflectionView:MiniCarouselReflectionView;
		private var backGround:CustomWindow;
		private var itemModel:ItemModel;
		private const ID:int=53;
		public function MinZuBaiMei()
		{
			initMiniCarouselReflectionView()
		}
		private function initMiniCarouselReflectionView():void
		{
			ScriptManager.getInstance().runScriptByName(ScriptName.STOP_RENDER,[]);
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVE_ANIMATE,[]);
			itemModel=new ItemModel();
			backGround=new CustomWindow(itemModel.getSwfUrl(ID),itemModel.getText(ID));
			backGround.addEventListener(CustomWindowEvent.SWF_COMPLETE,on_swf_complete);
			backGround.addEventListener(CustomWindowEvent.WINDOW_CLOSE,on_close);
			this.addChild(backGround);
		}
		private function on_swf_complete(e:CustomWindowEvent):void
		{
			miniCarouselReflectionView=new MiniCarouselReflectionView();
			backGround.addChild(miniCarouselReflectionView);
			miniCarouselReflectionView.x=130;
			miniCarouselReflectionView.y=150;
		}
		private function on_close(e:CustomWindowEvent):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				backGround.dispatchEvent(new Event(Event.CLOSE));
				PluginManager.getInstance().removePluginById("MinZuBaiMeiModule");
			}
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(backGround,CustomWindowEvent.SWF_COMPLETE,on_swf_complete);
			MemoryRecovery.getInstance().gcFun(backGround,CustomWindowEvent.WINDOW_CLOSE,on_close);
			if(itemModel!=null)
			{
				itemModel.dispose();
			}
			if(miniCarouselReflectionView!=null)
			{
				if(miniCarouselReflectionView.parent!=null)
				{
					miniCarouselReflectionView.parent.removeChild(miniCarouselReflectionView);
				}
				miniCarouselReflectionView.dispose();
				miniCarouselReflectionView=null;
			}
			if(backGround!=null)
			{
				if(backGround.parent!=null)
				{
					backGround.parent.removeChild(backGround);
				}
				backGround.dispose();
				backGround=null;
			}
			MyGC.gc();
		}
	}
}
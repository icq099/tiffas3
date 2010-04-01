package lxfa.minzubaimei.view
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import lsd.CustomWindow.CustomWindow;
	import lsd.CustomWindow.CustomWindowEvent;
	
	import lxfa.model.ItemModel;
	import lxfa.utils.MemoryRecovery;
	
	public class MinZuBaiMei extends EventDispatcher
	{
		private var miniCarouselReflectionView:MiniCarouselReflectionView;
		private var backGround:CustomWindow;
		private var itemModel:ItemModel;
		private const ID:int=53;
		public function MinZuBaiMei()
		{
			MainSystem.getInstance().addAPI("getMinZuBaiMei",initMiniCarouselReflectionView);
		}
		private function initMiniCarouselReflectionView():CustomWindow
		{
			MainSystem.getInstance().stopRender();
			itemModel=new ItemModel("NormalWindow");
			backGround=new CustomWindow(itemModel.getSwfUrl(ID),itemModel.getText(ID));
			backGround.addEventListener(CustomWindowEvent.SWF_COMPLETE,on_swf_complete);
			backGround.addEventListener(CustomWindowEvent.WINDOW_CLOSE,on_close);
			return backGround;
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
				MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["MinZuBaiMeiModule"]);
			}
		}
		public function dispose():void
		{
			MainSystem.getInstance().startRender();
			MemoryRecovery.getInstance().gcFun(backGround,CustomWindowEvent.SWF_COMPLETE,on_swf_complete);
			MemoryRecovery.getInstance().gcObj(miniCarouselReflectionView,true);
			MemoryRecovery.getInstance().gcObj(backGround,true);
		}
	}
}
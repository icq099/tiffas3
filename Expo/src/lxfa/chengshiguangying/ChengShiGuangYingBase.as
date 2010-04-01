package lxfa.chengshiguangying
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import lsd.CustomWindow.CustomWindow;
	import lsd.CustomWindow.CustomWindowEvent;
	
	import lxfa.model.ItemModel;
	import lxfa.utils.MemoryRecovery;
	
	public class ChengShiGuangYingBase extends EventDispatcher
	{
		private var itemModel:ItemModel;
		private var customWindow:CustomWindow;
		private var flatWall3D_Reflection:FlatWall3D_Reflection;
		private var ID:int;
		public function ChengShiGuangYingBase()
		{
			MainSystem.getInstance().addAPI("initChengShiGuangYing",init);
			MainSystem.getInstance().addAPI("getChengShiGuangYing",getChengShiGuangYing);
		}
		private function init(ID:int):void
		{
			this.ID=ID;
			MainSystem.getInstance().stopRender();
			itemModel=new ItemModel("NormalWindow");
			customWindow=new CustomWindow(itemModel.getSwfUrl(ID),itemModel.getText(ID));
			customWindow.addEventListener(CustomWindowEvent.SWF_COMPLETE,on_swf_complete);
			customWindow.addEventListener(CustomWindowEvent.WINDOW_CLOSE,dispose);
		}
		private function on_swf_complete(e:CustomWindowEvent):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
			init3DView();
		}
		private function init3DView():void
		{
			flatWall3D_Reflection=new FlatWall3D_Reflection(ID);
			flatWall3D_Reflection.x=14;
			flatWall3D_Reflection.y=80;
			customWindow.addChild(flatWall3D_Reflection);
		}
		private function getChengShiGuangYing():CustomWindow
		{
			return customWindow;
		}
		public function dispose(e:CustomWindowEvent):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				customWindow.dispatchEvent(new Event(Event.CLOSE));
				MemoryRecovery.getInstance().gcObj(flatWall3D_Reflection,true);
				MemoryRecovery.getInstance().gcFun(customWindow,CustomWindowEvent.SWF_COMPLETE,on_swf_complete);
				MemoryRecovery.getInstance().gcFun(customWindow,CustomWindowEvent.WINDOW_CLOSE,dispose);
				MemoryRecovery.getInstance().gcObj(customWindow,true);
			}
		}
	}
}
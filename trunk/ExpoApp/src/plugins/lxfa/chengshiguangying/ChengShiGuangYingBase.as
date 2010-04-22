package plugins.lxfa.chengshiguangying
{
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	
	import memory.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	import plugins.lsd.CustomWindow.CustomWindow;
	import plugins.lsd.CustomWindow.CustomWindowEvent;
	import plugins.model.ItemModel;

	public class ChengShiGuangYingBase extends UIComponent
	{
		private var itemModel:ItemModel;
		private var customWindow:CustomWindow;
		private var flatWall3D_Reflection:FlatWall3D_Reflection;
		private var ID:int;
		public function ChengShiGuangYingBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.SHOWCHENGSHIGUANGYING, init);
		}
		private function init(ID:int):void
		{
			this.ID=ID;
			ScriptManager.getInstance().runScriptByName(ScriptName.STOPRENDER,[]);
			itemModel=new ItemModel();
			customWindow=new CustomWindow(itemModel.getSwfUrl(ID), itemModel.getText(ID));
			customWindow.addEventListener(CustomWindowEvent.SWF_COMPLETE, on_swf_complete);
		}
		private function onAdded(e:Event):void
		{
			customWindow.addEventListener(CustomWindowEvent.WINDOW_CLOSE, on_customWindow_close);
			MemoryRecovery.getInstance().gcFun(flatWall3D_Reflection,Event.ADDED_TO_STAGE,onAdded);
			PluginManager.getInstance().removePluginById("ChengShiGuangYingModule");
		}
		private function on_swf_complete(e:CustomWindowEvent):void
		{
			this.addChild(customWindow);
			init3DView();
		}

		private function init3DView():void
		{
			flatWall3D_Reflection=new FlatWall3D_Reflection(ID);
			flatWall3D_Reflection.x=14;
			flatWall3D_Reflection.y=80;
			flatWall3D_Reflection.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			customWindow.addChild(flatWall3D_Reflection);
		}
		private function on_customWindow_close(e:CustomWindowEvent):void
		{
			PluginManager.getInstance().removePluginById("ChengShiGuangYingModule");
		}
		public function dispose(e:CustomWindowEvent):void
		{
			if (!MainSystem.getInstance().isBusy)
			{
				if(flatWall3D_Reflection!=null)
				{
					if(flatWall3D_Reflection.parent!=null)
					{
						flatWall3D_Reflection.parent.removeChild(flatWall3D_Reflection);
					}
					flatWall3D_Reflection.dispose();
					flatWall3D_Reflection=null;
				}
				MemoryRecovery.getInstance().gcFun(customWindow, CustomWindowEvent.SWF_COMPLETE, on_swf_complete);
				MemoryRecovery.getInstance().gcFun(customWindow, CustomWindowEvent.WINDOW_CLOSE, on_customWindow_close);
				if(customWindow!=null)
				{
					if(customWindow.parent!=null)
					{
						customWindow.parent.removeChild(customWindow);
					}
					customWindow.dispose();
					customWindow=null;
				}
			}
		}
	}
}
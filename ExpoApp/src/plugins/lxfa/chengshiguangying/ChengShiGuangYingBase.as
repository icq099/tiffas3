package plugins.lxfa.chengshiguangying
{
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
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
			ScriptManager.getInstance().addApi("initChengShiGuangYing", init);
			init(14);
		}

		private function init(ID:int):void
		{
			this.ID=ID;
			ScriptManager.getInstance().runScriptByName(ScriptName.STOPRENDER,[]);
			itemModel=new ItemModel();
			customWindow=new CustomWindow(itemModel.getSwfUrl(ID), itemModel.getText(ID));
			customWindow.addEventListener(CustomWindowEvent.SWF_COMPLETE, on_swf_complete);
			customWindow.addEventListener(CustomWindowEvent.WINDOW_CLOSE, on_customWindow_close);
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
				
				customWindow.removeChild(flatWall3D_Reflection);
				flatWall3D_Reflection.dispose();
				flatWall3D_Reflection=null;
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
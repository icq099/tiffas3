package plugins.lxfa.normalWindow
{
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	public class NormalWindowBase extends Sprite
	{
		private var normalWindowFactory:NormalWindowFactory;
		private var isPoped:Boolean;
		public function NormalWindowBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.SHOWNORMALWINDOW,showNormalWindow);
			ScriptManager.getInstance().addApi(ScriptName.REMOVENORMALWINDOW,dispose);
		}
		public function showNormalWindow(id:String,sid:int=0):void
		{
			ScriptManager.getInstance().runScriptByName(ScriptName.STOPRENDER,[]);
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVEANIMATE,[]);
			if(!isPoped)//让弹出的标准窗保持只有一个
			{
				isPoped=true;
				normalWindowFactory=new NormalWindowFactory(int(id));
				PopUpManager.addPopUp(normalWindowFactory,DisplayObject(Application.application), true);
	            PopUpManager.centerPopUp(normalWindowFactory);
	            normalWindowFactory.x=33;
	            normalWindowFactory.y=80;
			}
		}
		private function dispose():void
		{
			isPoped=false;
			normalWindowFactory.dispose();
			normalWindowFactory=null;
			ScriptManager.getInstance().runScriptByName(ScriptName.STARTRENDER,[]);
		}
	}
}
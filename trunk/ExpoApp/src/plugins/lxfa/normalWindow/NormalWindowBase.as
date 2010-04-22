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
		}
		public function showNormalWindow(id:String,sid:int=0):void
		{
			ScriptManager.getInstance().runScriptByName(ScriptName.STOPRENDER,[]);
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVEANIMATE,[]);
			if(!isPoped)
			{
				isPoped=true;
				normalWindowFactory=new NormalWindowFactory(int(id));
				PopUpManager.addPopUp(normalWindowFactory,DisplayObject(Application.application), true);
	            PopUpManager.centerPopUp(normalWindowFactory);
	            normalWindowFactory.x=33;
	            normalWindowFactory.y=80;
	            normalWindowFactory.addEventListener(Event.CLOSE,onnormalWindowFactoryClose);
			}
		}
		private function onnormalWindowFactoryClose(e:Event):void
		{
			this.dispatchEvent(e);
			isPoped=false;
			ScriptManager.getInstance().runScriptByName(ScriptName.STARTRENDER,[]);
		}
	}
}
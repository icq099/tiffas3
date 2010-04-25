package plugins.lxfa.normalWindow
{
	import core.manager.MainSystem;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	public class NormalWindowBase extends Sprite
	{
		private var normalWindowFactory:NormalWindowFactory;
		private var isPoped:Boolean;
		public function NormalWindowBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.SHOW_NORMAL_WINDOW,showNormalWindow);
			ScriptManager.getInstance().addApi(ScriptName.REMOVE_NORMAL_WINDOW,dispose);
		}
		public function showNormalWindow(id:String,sid:int=0):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				ScriptManager.getInstance().runScriptByName(ScriptName.STOP_RENDER,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.REMOVE_ANIMATE,[]);
				if(!isPoped)//让弹出的标准窗保持只有一个
				{
					isPoped=true;
					normalWindowFactory=new NormalWindowFactory(int(id));
					PopUpManager.addPopUp(normalWindowFactory,DisplayObject(Application.application), true);
		            PopUpManager.centerPopUp(normalWindowFactory);
		            normalWindowFactory.x=33;
		            normalWindowFactory.y=80;
				}
			}else
			{
				trace("系统繁忙啊");
			}
		}
		private function dispose():void
		{
			isPoped=false;
			normalWindowFactory.dispose();
			normalWindowFactory=null;
			ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
		}
	}
}
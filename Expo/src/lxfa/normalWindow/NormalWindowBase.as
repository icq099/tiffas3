package lxfa.normalWindow
{
	import communication.Event.MainSystemEvent;
	import communication.MainSystem;
	
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
			MainSystem.getInstance().addAPI("showNormalWindow",showNormalWindow);
		}
		public function showNormalWindow(id:String,sid:int=0):void
		{
			MainSystem.getInstance().stopRender();
			MainSystem.getInstance().runAPIDirectDirectly("removeAnimate",[]);
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
			MainSystem.getInstance().startRender();
		}
	}
}
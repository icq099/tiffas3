package lxfa.No3Swf.view
{
	import caurina.transitions.Tweener;
	
	import communication.Event.MainSystemEvent;
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	public class No3SwfBase extends UIComponent
	{
		private var flowerFlvSwf:SwfPlayer;
		public function No3SwfBase()
		{
			MainSystem.getInstance().isBusy=true;
			flowerFlvSwf=new SwfPlayer("movie/外馆效果.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
			flowerFlvSwf.x=-200;
			flowerFlvSwf.y=-100;
			flowerFlvSwf.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function onComplete(e:Event):void
		{
			MainSystem.getInstance().isBusy=false;
			this.addChild(flowerFlvSwf);
            MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			MainSystem.getInstance().addAutoClose(dispose,[]);
			MainSystem.getInstance().removePluginById("No3Module");
		}
		private function onClick(e:MouseEvent):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				flowerFlvSwf.enabled=false;
				MainSystem.getInstance().showPluginById("No4Module");
				MainSystem.getInstance().addEventListener(MainSystemEvent.ON_PLUGIN_READY,No4ModuleLoaded);
			}
		}
		private function No4ModuleLoaded(e:MainSystemEvent):void
		{
			MainSystem.getInstance().removePluginById("No3SwfModule");
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcObj(flowerFlvSwf,true);
		}
	}
}
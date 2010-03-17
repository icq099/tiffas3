package lxfa.No3Swf.view
{
	import caurina.transitions.Tweener;
	
	import communication.Event.MainSystemEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	
	import mx.core.UIComponent;
	
	public class No3SwfBase extends UIComponent
	{
		private var flowerFlvSwf:SwfPlayer;
		public function No3SwfBase()
		{
			flowerFlvSwf=new SwfPlayer("movie/外馆效果.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
			flowerFlvSwf.x=-200;
			flowerFlvSwf.y=-100;
			flowerFlvSwf.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function onComplete(e:Event):void
		{
			this.addChild(flowerFlvSwf);
		}
		private function onClick(e:MouseEvent):void
		{
			MainSystem.getInstance().showPluginById("No4Module");
			MainSystem.getInstance().addEventListener(MainSystemEvent.ON_PLUGIN_READY,No4ModuleLoaded);
		}
		private function No4ModuleLoaded(e:MainSystemEvent):void
		{
			MainSystem.getInstance().removePluginById("No3SwfModule");
		}
		public function dispose():void
		{
			if(flowerFlvSwf!=null)
			{
				flowerFlvSwf.parent.removeChild(flowerFlvSwf);
				flowerFlvSwf=null;
			}
		}
	}
}
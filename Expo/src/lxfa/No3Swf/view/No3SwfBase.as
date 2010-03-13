package lxfa.No3Swf.view
{
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
			MainSystem.getInstance().removePluginById("No3SwfModule");
			MainSystem.getInstance().showPluginById("No4Module");
		}
	}
}
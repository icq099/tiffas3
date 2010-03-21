package lxfa.No3Swf.view
{
	import caurina.transitions.Tweener;
	
	import communication.Event.MainSystemEvent;
	import communication.Event.PluginEvent;
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
			MainSystem.getInstance().addEventListener(PluginEvent.UPDATE,on_plugin_update);
			flowerFlvSwf=new SwfPlayer("movie/外馆效果.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
			flowerFlvSwf.x=-200;
			flowerFlvSwf.y=-100;
			flowerFlvSwf.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function on_plugin_update(e:PluginEvent):void
		{
			if(MainSystem.getInstance().hasEventListener(PluginEvent.UPDATE))
			{
				MainSystem.getInstance().removeEventListener(PluginEvent.UPDATE,on_plugin_update);
			}
			dispose();
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
			Tweener.addTween(this,{alpha:0,time:2,onComplete:on_dispose_complete});
		}
		private function on_dispose_complete():void
		{
			if(flowerFlvSwf!=null)
			{
				flowerFlvSwf.parent.removeChild(flowerFlvSwf);
				flowerFlvSwf=null;
			}
		}
	}
}
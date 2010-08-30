package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import yzhkof.ui.event.ComponentEvent;

	public class ComponentContainer extends ComponentBase
	{		
		public static const CHILD_CHANGE:String = "child_change";
		
		public function ComponentContainer()
		{
			super();
			addEventListener(Event.ADDED,__childAdd);
			addEventListener(Event.REMOVED,__childRemove);
		}
		private function __childAdd(e:Event):void
		{
			commitChage(CHILD_CHANGE);
			addChildEvent(e.target);
		}
		private function __childRemove(e:Event):void
		{
			commitChage(CHILD_CHANGE);
			removeChildEvent(e.target);
		}
		private function addChildEvent(child:Object):void
		{
			if(!(child is ComponentBase)) return;
			var comp:ComponentBase = child as ComponentBase;
			comp.addEventListener(ComponentEvent.COMPONENT_CHANGE,__childUpdate);
		}
		private function removeChildEvent(child:Object):void
		{
			if(!(child is ComponentBase)) return;
			var comp:ComponentBase = child as ComponentBase;
			comp.removeEventListener(ComponentEvent.COMPONENT_CHANGE,__childUpdate);
		}
		private function __childUpdate(e:Event):void
		{
//			commitChage(CHILD_CHANGE);
		}
	}
}
package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SwapDepthLayer extends Sprite
	{
		public function SwapDepthLayer()
		{
			super();
		}
		public function addSwapDepthChild(child:InteractiveObject):void
		{
			addChild(child);
			addEvent(child);
		}
		private function addEvent(child:InteractiveObject):void
		{
			child.addEventListener(MouseEvent.MOUSE_DOWN,__childMouseDown);
			child.addEventListener(Event.REMOVED_FROM_STAGE,__childRemoveFromStage);
		}
		private function __childMouseDown(e:Event):void
		{
			setChildIndex(InteractiveObject(e.currentTarget),numChildren - 1);
		}
		private function __childRemoveFromStage(e:Event):void
		{
			InteractiveObject(e.currentTarget).removeEventListener(MouseEvent.MOUSE_DOWN,__childMouseDown);
			InteractiveObject(e.currentTarget).removeEventListener(Event.REMOVED_FROM_STAGE,__childRemoveFromStage);
		}
	}
}
package test
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;

	public class IndexCanvas extends Canvas
	{
		public function IndexCanvas()
		{
			super();
			addEventListener(ChildExistenceChangedEvent.CHILD_ADD,onChildAdd);
		}
		private function onChildAdd(e:ChildExistenceChangedEvent):void{
			e.relatedObject.addEventListener(MouseEvent.CLICK,onChildMouseClick);
		}
		private function onChildMouseClick(e:Event):void{
			setChildIndex(DisplayObject(e.currentTarget),numChildren-1);
		}
		
	}
}
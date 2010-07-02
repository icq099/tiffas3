package yzhkof.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import yzhkof.MyGraphy;

	public class DragPanel extends BackGroudContainer
	{
		protected var _dragContainer:DisplayObjectContainer=new Sprite;
		protected var _content:DisplayObjectContainer=new Sprite;
		public function DragPanel()
		{
			super();
			init();
			initEvent();
		}
		private function init():void
		{
			addChild(_dragContainer);
			addChild(_content);
			_dragContainer.addChild(MyGraphy.drawRectangle(20,20));
			_content.y=20;
			Sprite(_dragContainer).buttonMode=true;
		}
		private function initEvent():void
		{
			_dragContainer.addEventListener(MouseEvent.MOUSE_DOWN,__onStartDrag);
			_dragContainer.addEventListener(MouseEvent.MOUSE_UP,__onStopDrag)
		}
		private function __onStartDrag(e:Event):void
		{
			this.startDrag();
		}
		private function __onStopDrag(e:Event):void
		{
			this.stopDrag();
		}
		public function get content():DisplayObjectContainer
		{
			return _content;
		} 
		
	}
}
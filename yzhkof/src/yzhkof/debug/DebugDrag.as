package yzhkof.debug
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class DebugDrag
	{
		public var data:*;
		private var _target:DisplayObject;
		private var state:int = 1;
		private var preX:Number;
		private var preY:Number;
		public function DebugDrag(target:DisplayObject = null)
		{
			_target = target;
			addEvent()
		}
		private function addEvent():void
		{
			if(target == null) return;
			if(target.stage) target.stage.addEventListener(MouseEvent.MOUSE_DOWN,__mouseDown);
			state = 1;
		}
		private function removeEvent():void
		{
			if(target == null) return;
			if(target.stage) target.stage.removeEventListener(MouseEvent.MOUSE_DOWN,__mouseDown);
			target.removeEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		private function __enterFrame(event:Event):void
		{
			target.x += target.parent.mouseX - preX;
			target.y += target.parent.mouseY - preY;
			preX = target.parent.mouseX;
			preY = target.parent.mouseY;
		}
		public function stop():void
		{
			target.removeEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		private function __mouseDown(event:MouseEvent):void
		{
			if(state >0)
			{
				state = 0;
				preX = target.parent.mouseX;
				preY = target.parent.mouseY;
				target.addEventListener(Event.ENTER_FRAME,__enterFrame);
			}
			else
			{
				stop();
			}
		}
		protected final function callBackFunction(fun:Function):void
		{
			if(fun == null) return;
			if(fun.length>0)
				fun(this);
			else
				fun();
		}

		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(value:DisplayObject):void
		{
			removeEvent();
			_target = value;
			addEvent();
		}

	}
}
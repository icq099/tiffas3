package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ComponentBase extends Sprite
	{
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _chages:Object = {};
		
		public static const SIZE_CHANGE:String = "size_change";
		public static const CHILD_CHANGE:String = "child_change";
		
		public function ComponentBase()
		{
			super();
			addEventListener(Event.ADDED,__childAdd);
			addEventListener(Event.REMOVED,__childRemove);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			if(value == _width) return;
			_width = value;
			commitChage(SIZE_CHANGE);
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			if(value == _height) return;
			_height = value;
			commitChage(SIZE_CHANGE);
		}
		public function get contentWidth():Number
		{
			return super.width;
		}

		public function get contentHeight():Number
		{
			return super.height;
		}
		protected function commitChage(changeType:String):void
		{
			_chages[changeType] = true;
			upDateNextRend();
		}
		protected function upDateNextRend():void
		{
			if(stage)
			{
				stage.invalidate();
				addEventListener(Event.RENDER,__onScreenRend);
			}
		}
		protected function onDraw():void
		{
			
		}
		private function __addToStage(e:Event):void
		{
			upDateNextRend();
		}
		private function __childAdd(e:Event):void
		{
			commitChage(CHILD_CHANGE);
		}
		private function __childRemove(e:Event):void
		{
			commitChage(CHILD_CHANGE);
		}
		public final function draw():void
		{
			onDraw();
			removeEventListener(Event.RENDER,__onScreenRend);
			_chages = {};
		}
		private function __onScreenRend(e:Event):void
		{
			removeEventListener(Event.RENDER,__onScreenRend);
			onDraw();
		}

	}
}
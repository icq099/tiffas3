package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ComponentBase extends ChangeableSprite
	{
		protected var _width:Number=0;
		protected var _height:Number=0;
		
//		protected var _chages:Object;
		
		public static const SIZE_CHANGE:String = "size_change";
		
		public function ComponentBase()
		{
			super();
		}
//		override protected function initChangealePropertys():void
//		{
//			registChangeableProperty("width");
//			registChangeableProperty("height");
//		}
		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			if(value == _width) return;
			_width = value;
			commitChage("width");
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			if(value == _height) return;
			_height = value;
			commitChage("height");
		}
		public function get contentWidth():Number
		{
			return super.width;
		}

		public function get contentHeight():Number
		{
			return super.height;
		}
	}
}
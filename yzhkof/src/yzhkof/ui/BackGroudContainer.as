package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class BackGroudContainer extends ComponentBase
	{
		protected var _color:uint;
		private var _alpha:Number;
		private var _shadow:Boolean = false;
		public function BackGroudContainer(color:uint=0xffffff,alpha:Number=1)
		{
			super();
			this._color=color;
			_alpha=alpha;
			shadow = true;
		}
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			if(_color == value) return;
			_color=value;
			commitChage("color");
		}
		override protected function onDraw():void
		{
			drawBackGround();
		}
		protected function drawBackGround():void
		{
			graphics.clear();
			graphics.beginFill(_color,_alpha);
			graphics.drawRect(0,0,contentWidth,contentHeight);
			graphics.endFill();
		}

		public function get shadow():Boolean
		{
			return _shadow;
		}

		public function set shadow(value:Boolean):void
		{
			if(_shadow == value) return;
			_shadow = value;
			filters = [new DropShadowFilter(0,0,0)];
		}

	}
}
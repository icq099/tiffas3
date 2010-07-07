package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class BackGroudContainer extends ComponentBase
	{
		protected var _color:uint;
		private var _alpha:Number;
		public function BackGroudContainer(color:uint=0xffffff,alpha:Number=1)
		{
			super();
			this._color=color;
			_alpha=alpha;
		}
		override protected function initChangeables():void
		{
			super.initChangeables();
			registChangeableThings("color");
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
	}
}
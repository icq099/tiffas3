package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class BackGroudContainer extends Sprite
	{
		private var _color:uint;
		private var _alpha:Number;
		public function BackGroudContainer(color:uint=0xffffff,alpha:Number=1)
		{
			super();
			this._color=color;
			_alpha=alpha;
		}
		public override function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			//drawBackGround();
			return child;
		}
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			_color=value;
			drawBackGround();
		}
		public function drawBackGround():void
		{
			graphics.clear();
			graphics.beginFill(_color,_alpha);
			graphics.drawRect(0,0,getBounds(this).width,getBounds(this).height);
			graphics.endFill();
		}
		
	}
}
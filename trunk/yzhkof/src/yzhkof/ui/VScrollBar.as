package yzhkof.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import yzhkof.MyGraphy;
	import yzhkof.ui.mouse.MouseManager;
	import yzhkof.util.Helpers;

	public class VScrollBar extends ComponentBase
	{
		private static const BAR_WIDTH:Number = 10;
		private var thumb:Sprite = MyGraphy.drawRectangle();
		private var dragRectangle:Rectangle = new Rectangle();
		
		private var _maxScrollV:Number = 0;
		private var _scrollV:Number = 0;
		
		public function VScrollBar()
		{
			super();
			init();
		}
		override protected function initChangeables():void
		{
			registChangeableThings("scrollV");
			registChangeableThings("maxScrollV");
		}
		private function init():void
		{
			width = BAR_WIDTH;
			thumb.width = BAR_WIDTH;
			thumb.height = 20;
			thumb.buttonMode = true;
			thumb.addEventListener(MouseEvent.MOUSE_DOWN,__thumbMouseDown);
			thumb.addEventListener(MouseManager.STAGE_UP_EVENT,__thumbMouseUp);
			thumb.addEventListener(MouseManager.MOUSE_DOWN_AND_DRAGING_EVENT,__thumbDraging);
			MouseManager.registExtendMouseEvent(thumb);
			addChild(thumb);
		}
		private function __thumbMouseDown(e:Event):void
		{
			thumb.startDrag(false,dragRectangle);
		}
		private function __thumbMouseUp(e:Event):void
		{
			thumb.stopDrag();
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function __thumbDraging(e:Event):void
		{
			updateDataByThumbPosition();
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function updateThumbPositionByData():void
		{
			thumb.y = (_scrollV/_maxScrollV)*(height-thumb.height);
		}
		private function updateDataByThumbPosition():void
		{
			_scrollV = thumb.y/(height - thumb.height)*_maxScrollV;
		}
		override protected function onDraw():void
		{
			drawScrollLine();
			dragRectangle.height = height - thumb.height;
			updateThumbPositionByData();
		}
		private function drawScrollLine():void
		{
			graphics.lineStyle(1);
			graphics.moveTo(BAR_WIDTH/2,0);
			graphics.lineTo(BAR_WIDTH/2,height);
		}
		public function get maxScrollV():Number
		{
			return _maxScrollV;
		}
		public function set maxScrollV(value:Number):void
		{
			if(_maxScrollV == value) return;
			_maxScrollV = value;
			commitChage("maxScrollV");
		}
		public function get scrollV():Number
		{
			return _scrollV;
		}
		public function set scrollV(value:Number):void
		{
			if(_scrollV == value) return;
			if(_scrollV>_maxScrollV)
			{
				_scrollV = _maxScrollV
			}
			else if(_scrollV<0)
			{
				_scrollV = 0;
			}
			else
			{
				_scrollV = value;
			}
			dispatchEvent(new Event(Event.CHANGE));
			commitChage("scrollV");
		}
	}
}
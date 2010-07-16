package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ScrollPanel extends ComponentContainer
	{
		private var vScrollBar:VScrollBar = new VScrollBar();
		private var viewRectangle:Rectangle = new Rectangle();
		private var contentContainer:Sprite = new Sprite();
		private var rectContaner:Sprite = new Sprite();
		private var _source:DisplayObject;
		
		private var _maxScrollV:Number = 0;
		private var _scrollV:Number = 0;
		
		public function ScrollPanel()
		{
			super();
			init();
		}
		private function init():void
		{
			rectContaner.addChild(contentContainer);
			addChild(rectContaner);
			addChild(vScrollBar);
			vScrollBar.addEventListener(Event.CHANGE,__scrollChange);
		}
		private function __scrollChange(e:Event):void
		{
			viewRectangle.y = _scrollV = vScrollBar.scrollV;
			rectContaner.scrollRect = viewRectangle;
		}
		private function updateScrollByContent():void
		{
			_maxScrollV = contentContainer.height - height;
			if(_maxScrollV<0)
				_maxScrollV = 0;
			vScrollBar.maxScrollV = _maxScrollV
			if(_scrollV > _maxScrollV)
			{
				_scrollV = _maxScrollV;
			}
			vScrollBar.scrollV = _scrollV; 
		}
		override public function set height(value:Number):void
		{
			super.height = value;
			vScrollBar.height = height;
		}
		override public function set width(value:Number):void
		{
			super.width = value;
			vScrollBar.x = width - vScrollBar.width;
		}
		override protected function onDraw():void
		{
			viewRectangle.width = width - vScrollBar.width;
			viewRectangle.height = height;
			rectContaner.scrollRect = viewRectangle;
		}
		public function get maxScrollV():Number
		{
			return _maxScrollV;
		}
		public function get scrollV():Number
		{
			return _scrollV;
		}
		public function set scrollV(value:Number):void
		{
			_scrollV = value;
		}
		private function __childSizeChange(e:Event):void
		{
			updateScrollByContent();
		}
		public function get source():DisplayObject
		{
			return _source;
		}
		public function set source(value:DisplayObject):void
		{
			if(_source == value) return;
			if(_source != null)
				contentContainer.removeChildAt(0);
			_source = value;
			if(_source)
				contentContainer.addChild(_source);
			updateScrollByContent();
			if(_source is ComponentBase)
				_source.addEventListener(UPDATE,__childSizeChange);
			commitChage(CHILD_CHANGE);
		}
	}
}
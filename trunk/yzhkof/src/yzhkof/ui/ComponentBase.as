package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import yzhkof.ui.event.ComponentEvent;
	
	/**
	 * 重绘完成发送 
	 */	
	[Event(name = "update",type = "yzhkof.ui.event.ComponentEvent")]
	/**
	 * 准备下次重绘发送 
	 */	
	[Event(name = "CHANGE_COMPONENT",type = "yzhkof.ui.event.ComponentEvent")]
	public class ComponentBase extends ChangeableSprite
	{
		protected var _width:Number=0;
		protected var _height:Number=0;
		
		public function ComponentBase()
		{
			super();
		}
		override protected function initChangeables():void
		{
			registChangeableThings("width");
			registChangeableThings("height");
		}
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
		override protected function commitChage(changeThing:String="default_change"):void
		{
			super.commitChage(changeThing);
			if(hasEventListener(ComponentEvent.CHANGE_COMPONENT))
				dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_COMPONENT));
		}
		public function get contentWidth():Number
		{
			return super.width;
		}
		public function get contentHeight():Number
		{
			return super.height;
		}
		override final protected function afterDraw():void
		{
			super.afterDraw()
			dispatchEvent(new ComponentEvent(ComponentEvent.UPDATE));
		}
	}
}
package yzhkof.ui
{
	import yzhkof.ui.event.ComponentEvent;
	
	/**
	 * 重绘完成发送 
	 */	
	[Event(name = "DRAW_COMPLETE",type = "yzhkof.ui.event.ComponentEvent")]
	/**
	 * 准备下次重绘发送 
	 */	
	[Event(name = "COMPONENT_CHANGE",type = "yzhkof.ui.event.ComponentEvent")]
	public class ComponentBase extends CommitingSprite
	{
		protected var _width:Number=0;
		protected var _height:Number=0;
		
		public function ComponentBase()
		{
			super();
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
			if(hasEventListener(ComponentEvent.COMPONENT_CHANGE))
				dispatchEvent(new ComponentEvent(ComponentEvent.COMPONENT_CHANGE));
		}
		public function get contentWidth():Number
		{
			return super.width;
		}
		public function get contentHeight():Number
		{
			return super.height;
		}
		/**
		 * 子类覆盖drawComplete代替afterDraw; 
		 * 
		 */	
		override final protected function afterDraw():void
		{
			super.afterDraw()
			dispatchEvent(new ComponentEvent(ComponentEvent.DRAW_COMPLETE));
			drawComplete();
		}
		protected function drawComplete():void
		{
			
		}
	}
}
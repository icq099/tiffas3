package yzhkof.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DelayRendSprite extends Sprite
	{
		private var _isCaneled:Boolean = false;
		public function DelayRendSprite()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		protected function upDateNextRend():void
		{
			_isCaneled = false;
			if(stage)
			{
				stage.invalidate();
				addEventListener(Event.RENDER,__onScreenRend);
			}
		}
		protected function cancelUpDataNextRend():void
		{
			removeEventListener(Event.RENDER,__onScreenRend);
		}
		protected function cancelCurrentRend():void
		{
			_isCaneled = true;
		}
		protected function beforDraw():void
		{
			
		}
		protected function onDraw():void
		{
			
		}
		protected function afterDraw():void
		{
			
		}
		private function __addToStage(e:Event):void
		{
			upDateNextRend();
		}
		
		public final function draw():void
		{
			beforDraw();
			if(_isCaneled == false)
			{
				onDraw();
				afterDraw();
			}
			_isCaneled =false;
			removeEventListener(Event.RENDER,__onScreenRend);
		}
		private function __onScreenRend(e:Event):void
		{
			draw();
		}
	}
}
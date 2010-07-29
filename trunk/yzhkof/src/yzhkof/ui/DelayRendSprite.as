package yzhkof.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DelayRendSprite extends Sprite
	{
		private var _isCanceled:Boolean = false;
		public function DelayRendSprite()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		protected function upDateNextRend():void
		{
			_isCanceled = false;
			if(stage)
			{
				stage.invalidate();
				removeEventListener(Event.RENDER,__onScreenRend);
				addEventListener(Event.RENDER,__onScreenRend);
			}
		}
		protected function cancelUpDataNextRend():void
		{
			removeEventListener(Event.RENDER,__onScreenRend);
		}
		protected function cancelCurrentRend():void
		{
			_isCanceled = true;
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
			onDraw();
			afterDraw();
			_isCanceled =false;
			removeEventListener(Event.RENDER,__onScreenRend);
		}
		private function __onScreenRend(e:Event):void
		{
			beforDraw();
			if(_isCanceled == false)
			{
				onDraw();
				afterDraw();
			}
			_isCanceled =false;
			removeEventListener(Event.RENDER,__onScreenRend);
		}
	}
}
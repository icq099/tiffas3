package yzhkof.display.render
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FrameRenderEngine extends RenderEngineBasic
	{
		private var ticker:Sprite;
		public function FrameRenderEngine()
		{
			super();
			ticker=new Sprite();
		}
		public override function startRender():void{
			ticker.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			super.startRender();
		}
		public override function stopRender():void
		{
			ticker.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			super.stopRender();
		}
		private function onEnterFrame(e:Event):void
		{
			rend();
		}
		
	}
}
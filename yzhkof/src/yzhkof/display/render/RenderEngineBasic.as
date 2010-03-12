package yzhkof.display.render
{
	import flash.events.EventDispatcher;
	
	import yzhkof.display.render.event.RenderEvent;
	[Event(name="on_rend",type="yzhkof.display.render.event.RenderEvent")]
	public class RenderEngineBasic extends EventDispatcher
	{
		public function RenderEngineBasic()
		{
		}
		public function startRender():void
		{
			rend();
		}
		public function stopRender():void
		{
			
		}
		public function rend():void
		{
			dispatchEvent(new RenderEvent(RenderEvent.ON_REND));
		}

	}
}
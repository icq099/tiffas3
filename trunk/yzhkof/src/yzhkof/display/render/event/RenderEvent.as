package yzhkof.display.render.event
{
	import flash.events.Event;

	public class RenderEvent extends Event
	{
		public static const ON_REND:String="ON_REND";
		public function RenderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
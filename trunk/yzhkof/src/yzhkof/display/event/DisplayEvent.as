package yzhkof.display.event
{
	import flash.events.Event;

	public class DisplayEvent extends Event
	{
		public static const SIZE_UPDATA:String="SIZE_UPDATA";
		public function DisplayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
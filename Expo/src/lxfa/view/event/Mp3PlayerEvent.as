package lxfa.view.event
{
	import flash.events.Event;

	public class Mp3PlayerEvent extends Event
	{
		public static const COMPLETE:String="Mp3PlayerEvent.COMPLETE";
		public function Mp3PlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
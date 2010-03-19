package communication.Event
{
	import flash.events.Event;

	public class PluginEvent extends Event
	{
		public static const UPDATE:String="PluginEvent.UPDATE";
		public function PluginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
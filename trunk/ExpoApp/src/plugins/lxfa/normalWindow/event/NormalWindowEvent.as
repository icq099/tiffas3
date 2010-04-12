package plugins.lxfa.normalWindow.event
{
	import flash.events.Event;

	public class NormalWindowEvent extends Event
	{
		public static var SHOW:String="NormalWindowEvent.SHOW";
		public static var REMOVE:String="NormalWindowEvent.REMOVE";
		public function NormalWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
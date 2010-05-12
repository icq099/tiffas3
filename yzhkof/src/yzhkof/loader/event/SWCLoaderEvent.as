package yzhkof.loader.event
{
	import flash.events.Event;
	
	public class SWCLoaderEvent extends Event
	{
		public static const LIBRARY_ATTACH_COMPLETE:String="LIBRARY_ATTACH_COMPLETE";
		public function SWCLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
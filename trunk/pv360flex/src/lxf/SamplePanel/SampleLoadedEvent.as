package lxf.SamplePanel
{
	import flash.events.Event;

	public class SampleLoadedEvent extends Event
	{
		public static const sampleLoaded:String="SampleLoadedEvent.sampleLoaded";
		public function SampleLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
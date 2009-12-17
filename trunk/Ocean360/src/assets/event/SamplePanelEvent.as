package assets.event
{
	import flash.events.Event;
	public class SamplePanelEvent extends Event
	{
		public static const FAILED:String="SamplePanelEvent.FAILED";
		public static const START_UPLOAD:String="SamplePanelEvent.START_UPLOAD";
		public function SamplePanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}
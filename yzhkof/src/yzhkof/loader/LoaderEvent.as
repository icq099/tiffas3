package yzhkof.loader
{
	import flash.events.Event;

	public class LoaderEvent extends Event
	{
		public static const NEXT_STEP:String="LoaderEvent.NEXT_STEP";
		public function LoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
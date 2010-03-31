package lsd.CustomWindow
{
	import flash.events.Event;
	
	public class CustomWindowEvent extends Event
	{
		public static const SWF_COMPLETE:String="swf_complete";
		public static const WINDOW_CLOSE:String="window_close";
		
		public function CustomWindowEvent(type:String)
		{
			super(type);
		}

	}
}
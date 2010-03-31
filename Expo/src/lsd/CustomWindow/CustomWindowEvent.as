package lsd.CustomWindow
{
	import flash.events.Event;
	
	public class CustomWindowEvent extends Event
	{
		public static const CUSTOMWINOW_SWFLOAD:String="customwindw_swfload";
		public static const CUSTOMWINOW_CLOSE:String="customwindow_close";
		
		public function CustomWindowEvent()
		{
			super(type);
		}

	}
}
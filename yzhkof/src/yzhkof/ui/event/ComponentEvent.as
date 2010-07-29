package yzhkof.ui.event
{
	import flash.events.Event;
	
	public class ComponentEvent extends Event
	{
		public static const UPDATE:String = "UPDATE";
		public static const SIZE_UPDATE:String = "SIZE_UPDATE";
		public static const CHANGE_COMPONENT:String = "CHANGE_COMPONENT";
		public function ComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
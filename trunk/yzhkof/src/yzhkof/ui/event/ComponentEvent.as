package yzhkof.ui.event
{
	import flash.events.Event;
	
	public class ComponentEvent extends Event
	{
		public static const UPDATE:String = "UPDATE";
		public function ComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
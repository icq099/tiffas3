package core.manager.popupManager
{
	import flash.events.Event;

	public class PopupManagerEvent extends Event
	{
		public static var SHOW_POPUP:String="PopupManagerEvent.SHOW_POPUP";
		public static var REMOVE_POPUP:String="PopupManagerEvent.REMOVE_POPUP";
		public function PopupManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
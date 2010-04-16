package lsd.Event
{
	import flash.events.Event;

	public class PopUpEvent extends Event
	{
		public static const POPUP:String="popup"
		public var _popType:String;
		
		public function PopUpEvent(type:String,popType:String)
		{
			this._popType=popType;
			super(type);
		}
		
	}
}
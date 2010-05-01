package plugins.lxfa.animatePlayer
{
	import flash.events.Event;

	public class AnimatePlayerEvent extends Event
	{
		public static var SHOW_ANIMATE_IN:String="AnimatePlayerEvent.SHOW_ANIMATE_IN";
		public static var SHOW_ANIMATE_OUT:String="AnimatePlayerEvent.SHOW_ANIMATE_OUT";
		public static var SHOW_ANIMATE_SAY:String="AnimatePlayerEvent.SHOW_ANIMATE_SAY";
		public static var ALL_STOP:String="AnimatePlayerEvent.ALL_STOP";
		public static var REFRESH_TEXT:String="AnimatePlayerEvent.REFRESH_TEXT";
		public static var REFRESH_TEXT_STATE:String="AnimatePlayerEvent.REFRESH_TEXT_STATE";
		public var text:String="";
		public var hasText:Boolean;
		public function AnimatePlayerEvent(type:String,text:String="",hasText:Boolean=true, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.text=text;
			this.hasText=hasText;
		}
		
	}
}
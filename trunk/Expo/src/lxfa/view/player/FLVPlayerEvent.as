package lxfa.view.player
{
	import flash.events.Event;

	public class FLVPlayerEvent extends Event
	{
		public static const NETSTREAMINIT:String="NETSTREAMINIT";
		public static const PLAYCOMPLETE:String="PLAYCOMPLETE";
		public function FLVPlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
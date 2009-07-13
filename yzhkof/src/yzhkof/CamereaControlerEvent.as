package yzhkof
{
	import flash.events.Event;

	public class CamereaControlerEvent extends Event
	{
		public static const UPDATA:String="UPDATA";
		public static const UPDATAED:String="UPDATAED";
		
		public function CamereaControlerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
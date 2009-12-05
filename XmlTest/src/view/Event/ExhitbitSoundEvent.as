package view.Event
{
	import flash.events.Event;

	public class ExhitbitSoundEvent extends Event
	{
		
		public static const PLAY:String="ExhitbitSoundEvent.RESUME";
		public static const PAUSE_OR_STOP:String="ExhitbitSoundEvent.PAUSE_OR_STOP";
		
		public function ExhitbitSoundEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
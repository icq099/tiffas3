package lsd.Event
{
	import flash.events.Event;
	
	public class SendEffectEvent extends Event
	{
		public static const EFFECT:String="effect"
		public var _effect:String;
		
		public function SendEffectEvent(type:String,effect:String)
		{
			this._effect=effect;
			super(type);
		}

	}
}
package communication.Event
{
	import flash.events.Event;

	public class ScriptEvent extends Event
	{
		public static var RUN:String="ScriptEvent.RUN";
		public var script:String;
		
		public function ScriptEvent(type:String,script:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.script=script;
		}
		public override function clone():Event{
			return new ScriptEvent(type,script,bubbles,cancelable);		
		}
		
	}
}
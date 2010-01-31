package communication.Event
{
	import flash.events.Event;

	public class ScriptAPIAddEvent extends Event
	{
		public static var ADD_API:String="ScriptEvent.ADD_API";
		public static var REMOVE_API:String="ScriptEvent.REMOVE_API";
		public var fun_name:String;
		public var fun:Function;
		public function ScriptAPIAddEvent(type:String,fun_name:String,fun:Function=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.fun_name=fun_name;
			this.fun=fun;
		}
		public override function clone():Event{
			return new ScriptAPIAddEvent(type,fun_name,fun,bubbles,cancelable);
		}
		
	}
}
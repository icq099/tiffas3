package core.communication.Event
{
	import flash.events.Event;

	public class ScriptEvent extends Event
	{
		public static var RUN:String="ScriptEvent.RUN";
		public static var RUN_BY_FUNCTION:String="ScriptEvent.RUN_BY_FUNCTION";
		public var script:String;
		public var function_name:String;
		public var param:Array;
		
		public function ScriptEvent(type:String,script:String=null,function_name:String=null,param:Array=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.script=script;
			this.function_name=function_name;
			this.param=param;
		}
		public override function clone():Event{
			return new ScriptEvent(type,script,function_name,param,bubbles,cancelable);
		}
	}
}
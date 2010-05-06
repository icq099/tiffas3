package yzhkof.util
{
	import flash.events.Event;
	
	public class ObjectEvent extends Event
	{
		public var obj:Object;
		public function ObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,obj:Object=null)
		{
			super(type, bubbles, cancelable);
			this.obj=obj;
		}
		public override function clone():Event
		{
			return new ObjectEvent(type,bubbles,cancelable,obj);
		}
	}
}
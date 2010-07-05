package yzhkof.ui
{
	import flash.events.Event;

	public class ComponentContainer extends ComponentBase
	{		
		public static const CHILD_CHANGE:String = "child_change";
		
		public function ComponentContainer()
		{
			super();
			addEventListener(Event.ADDED,__childAdd);
			addEventListener(Event.REMOVED,__childRemove);
		}
		private function __childAdd(e:Event):void
		{
			commitChage();
		}
		private function __childRemove(e:Event):void
		{
			commitChage();
		}
	}
}
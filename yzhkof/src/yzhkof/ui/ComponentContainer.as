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
		override protected function initChangeables():void
		{
			super.initChangeables();
			registChangeableThings("child_change",false);
		}
		private function __childAdd(e:Event):void
		{
			commitChage(CHILD_CHANGE);
		}
		private function __childRemove(e:Event):void
		{
			commitChage(CHILD_CHANGE);
		}
	}
}
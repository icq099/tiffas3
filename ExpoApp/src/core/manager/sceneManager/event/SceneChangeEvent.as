package core.manager.sceneManager.event
{
	import flash.events.Event;

	public class SceneChangeEvent extends Event
	{
		public static var INIT:String="SceneChangeEvent.INIT";
		public static var COMPLETE:String="SceneChangeEvent.COMPLETE";
		public var id:int;
		public function SceneChangeEvent(type:String,id:int=-1,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.id=id;
		}
		
	}
}
package communication.Event
{
	import flash.events.Event;

	public class SceneChangeEvent extends Event
	{
		public static const INIT:String="SceneChangeEvent.INIT";
		public static const COMPLETE:String="SceneChangeEvent.COMPLETE";
		public var id:int;
		public function SceneChangeEvent(type:String,scene_id:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.id=scene_id;
		}
		public override function clone():Event{
			return new SceneChangeEvent(SceneChangeEvent.COMPLETE,id,bubbles,cancelable);		
		}
	}
}
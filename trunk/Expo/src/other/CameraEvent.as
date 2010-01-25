package other
{
	import flash.events.Event;

	public class CameraEvent extends Event
	{
		public static const CAMERA_ROTATION_CHANGE:String="CAMERA_ROTATION_CHANGE";
		
		public function CameraEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
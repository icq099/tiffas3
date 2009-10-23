package communication.Event
{
	import communication.camera.CameraProxy;
	
	import flash.events.Event;
	
	import scripsimple.ScriptSimple;

	public class MainSystemEvent extends Event
	{
		public static var INIT:String="INIT";
		public var camera:CameraProxy;
		public var script_runer:ScriptSimple;
		public function MainSystemEvent(type:String,camera:CameraProxy,script_runer:ScriptSimple, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.camera=camera;
			this.script_runer=script_runer;
		}
		
	}
}
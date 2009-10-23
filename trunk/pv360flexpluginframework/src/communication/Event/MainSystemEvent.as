package communication.Event
{
	import communication.camera.CameraProxy;
	
	import flash.events.Event;
	
	import scripsimple.ScriptSimple;

	public class MainSystemEvent extends Event
	{
		public static var INIT:String="MainSystemEvent.INIT";
		public static var ON_PLUGIN_READY:String="MainSystemEvent.ON_PLUGIN_READY";
		public var camera:CameraProxy;
		public var script_runer:ScriptSimple;
		public var id:String;
		public function MainSystemEvent(type:String,camera:CameraProxy=null,script_runer:ScriptSimple=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.camera=camera;
			this.script_runer=script_runer;
		}
		public function paramOnPluginReady(id:String):void{
			this.id=id;
		}
		
	}
}
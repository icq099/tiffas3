package communication
{
	import communication.Event.ScriptAPIAddEvent;
	import communication.Event.ScriptEvent;
	import communication.camera.CameraProxy;
	
	import flash.events.EventDispatcher;
	
	import org.papervision3d.cameras.FreeCamera3D;
	
	[Event(name="add_api", type="communication.Event.ScriptAPIAddEvent")]
	[Event(name="run", type="communication.Event.ScriptEvent")]
	[Event(name="change", type="communication.Event.SceneChangeEvent")]
	
	public class MainSystem extends EventDispatcher
	{
		private static var instance:MainSystem;
		public var camera:CameraProxy;
		public function MainSystem()
		{
			if(instance==null){
				super(this);
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():MainSystem{
			if(instance==null) instance=new MainSystem();
			return instance;
		}
		public function setCameraRotaion(rotaX:Number=0,rotaY:Number=0):void{
			runScript("setCameraRotaion("+rotaX+","+rotaY+");");
		}
		public function addAPI(fun_name:String,fun:Function):void{
			dispatchEvent(new ScriptAPIAddEvent(ScriptAPIAddEvent.ADD_API,fun_name,fun));
		}
		public function runScript(script:String):void{
			dispatchEvent(new ScriptEvent(ScriptEvent.RUN,script));
		}
		public function gotoScene(scene_id:int):void{
			runScript("gotoScene("+scene_id+");");
		}
		public function showPluginById(id:int):void{
			runScript("showPluginById("+id+");");
		}
		public function removePluginById(id:int):void{
			runScript("removePluginById("+id+");");
		}
	}
}
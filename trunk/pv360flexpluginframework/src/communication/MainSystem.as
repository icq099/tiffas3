package communication
{
	import communication.Event.ScriptEvent;
	
	import flash.events.EventDispatcher;
	
	[Event(name="add_api", type="communication.Event.ScriptAPIAddEvent")]
	[Event(name="run", type="communication.Event.ScriptEvent")]
	
	public class MainSystem extends EventDispatcher
	{
		private static var instance:MainSystem;
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
		public function runScript(script:String):void{
			dispatchEvent(new ScriptEvent(ScriptEvent.RUN,script));
		}
		public function gotoScene(scene_id:int):void{
			runScript("gotoScene("+scene_id+");");
		}
	}
}
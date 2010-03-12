package yzhkof.display.render
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import yzhkof.display.render.event.RenderEvent;
	[Event(name="on_rend",type="yzhkof.display.render.event.RenderEvent")]
	public class RenderDispatcher extends EventDispatcher
	{
		private static var _instance:RenderDispatcher;
		private var _engine:RenderEngineBasic;
		
		public function RenderDispatcher()
		{
			if(_instance)
				throw new Error("error");
			_instance=this;
			engine=new FrameRenderEngine();
			engine.startRender();
		}
		public static function getInstance():RenderDispatcher
		{
			if(!_instance)
				return new RenderDispatcher();
			return _instance;
		}
		public function set engine(value:RenderEngineBasic):void{
			if(_engine)
				_engine.removeEventListener(RenderEvent.ON_REND,onRend);
			_engine=value;
			_engine.addEventListener(RenderEvent.ON_REND,onRend);
			
		}
		public function get engine():RenderEngineBasic{
			return _engine;
		}
		public function startRender():void{
			_engine.startRender();
		}
		public function stopRender():void{
			_engine.stopRender();
		}
		public function rend():void
		{
			_engine.rend();
		}
		private function onRend(e:Event):void
		{
			dispatchEvent(new RenderEvent(RenderEvent.ON_REND));
		}
	}
}
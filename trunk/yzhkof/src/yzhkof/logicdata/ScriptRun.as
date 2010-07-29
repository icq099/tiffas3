package yzhkof.logicdata
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	
	import yzhkof.debug.ScriptRuner;

	public class ScriptRun extends EventDispatcher
	{
		public var data:Object;
		public var urlLoader:URLLoader;
		private var _loader:Loader;
		public var script:String;
		public var bytes:ByteArray;
		public var paramOfScriptRun:Object;
		public function ScriptRun()
		{
		}

		public function get loader():Loader
		{
			return _loader;
		}

		public function set loader(value:Loader):void
		{
			if(_loader) return;
			_loader = value;
			addEventListener(Event.COMPLETE,__loaderComplete);
		}
		private function __loaderComplete(e:Event):void
		{
			if(ScriptRuner.global.run && ScriptRuner.global.run is Function)
			{
				if(ScriptRuner.global.run.length>0)
					ScriptRuner.global.run(paramOfScriptRun);
				else
					ScriptRuner.global.run();
			}
		}

	}
}
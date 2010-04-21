package loaders.proxy
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import loaders.CompatibleLoader;
	import loaders.event.LoaderEvent;

	public class CompatibleLoaderProxy extends CompatibleLoader implements IManageLoader
	{
		public function CompatibleLoaderProxy()
		{
			addEventListener(Event.COMPLETE,onNextStep);
			addEventListener(IOErrorEvent.IO_ERROR,onNextStep);
			addEventListener(Event.UNLOAD,onNextStep);
		}
		public function managePause():void
		{
			try{
				super.close();
			}catch(e:Error){
			}
		}
		public function manageStart(value:Object):void
		{
			super.load(value);
		}
		
		public function manageUnload():void
		{
			super.unload();
		}
		
		public function manageResume(value:Object=null):void
		{
			super.load(value);
		}
		
		public function manageUnloadAndStop(gc:Boolean=true):void
		{
			super.unloadAndStop(gc);
		}
		public override function close():void{
			super.close();
			onNextStep();
		}
		public override function unload():void{
			super.unload();
			onNextStep();
		}
		public override function unloadAndStop(gc:Boolean=true):void{
			super.unloadAndStop(gc);
			onNextStep();
		}
		private function onNextStep(e:Event=null):void{
			dispatchEvent(new Event(LoaderEvent.NEXT_STEP));
		}
	}
}
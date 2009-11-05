package yzhkof.loader.proxy
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import yzhkof.loader.LoaderEvent;

	public class NormalLoaderProxy extends Loader implements IManageLoader
	{
		public function NormalLoaderProxy()
		{
			contentLoaderInfo.addEventListener(Event.COMPLETE,onNextStep);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNextStep);
			contentLoaderInfo.addEventListener(Event.UNLOAD,onNextStep);
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
			super.load(new URLRequest(String(value)));
		}
		public function manageUnload():void
		{
			super.unload();
		}
		public function manageResume(value:Object=null):void
		{
			super.load(new URLRequest(String(value)));
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
			super.unloadAndStop(gc)
			onNextStep();
		}
		private function onNextStep(e:Event=null):void{
			dispatchEvent(new Event(LoaderEvent.NEXT_STEP));
		}
	}
}
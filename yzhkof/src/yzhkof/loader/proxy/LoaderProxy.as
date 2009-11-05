package yzhkof.loader.proxy
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import yzhkof.loader.LoaderEvent;
[Event(name="complete", type="flash.events.Event")]
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="init", type="flash.events.Event")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
[Event(name="open", type="flash.events.Event")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
[Event(name="unload", type="flash.events.Event")]
[Event(name="next_step", type="yzhkof.loader.LoaderEvent")]
	public class LoaderProxy extends Sprite
	{
		protected var _loader:Object;
		protected var event_dispatcher:EventDispatcher; 
		public function LoaderProxy(loader:Object,eventDispatcher:EventDispatcher=null)
		{
			_loader=loader;
			event_dispatcher=eventDispatcher;
		}
		public final function unload():void{
			doUnload();
			dispatchEvent(new Event(LoaderEvent.NEXT_STEP));
		}
		public final function close():void{
			doClose();
			dispatchEvent(new Event(LoaderEvent.NEXT_STEP));
		}
		public final function unLoadAndStop(gc:Boolean=true):void{
			doUnLoadAndStop(gc);
			dispatchEvent(new Event(LoaderEvent.NEXT_STEP));
		}
		protected function doUnload():void{
		} 
		protected function doClose():void{
		} 
		protected function doUnLoadAndStop(gc:Boolean=true):void{
		} 
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			switch(type){
				case Event.COMPLETE:
				case Event.OPEN:
				case HTTPStatusEvent.HTTP_STATUS:
				case Event.INIT:
				case IOErrorEvent.IO_ERROR:
				case ProgressEvent.PROGRESS:
				case SecurityErrorEvent.SECURITY_ERROR:
				case Event.UNLOAD:
					event_dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
				break;
				default:
					super.addEventListener(type,listener,useCapture,priority,useWeakReference);
			}
		}
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			event_dispatcher.removeEventListener(type,listener,useCapture);
			super.removeEventListener(type,listener,useCapture);
		}
	}
}
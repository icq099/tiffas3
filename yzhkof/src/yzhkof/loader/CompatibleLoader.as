package yzhkof.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

[Event(name="complete", type="flash.events.Event")]
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="init", type="flash.events.Event")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
[Event(name="open", type="flash.events.Event")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
[Event(name="unload", type="flash.events.Event")]

	public class CompatibleLoader extends Sprite
	{
		protected var _content:DisplayObject;
		protected var _loader:Loader;
		
		public function CompatibleLoader()
		{
		}
		protected function reInitLoader():void{
			_content!=null?removeChild(_content):null;
			if(_loader!=null){
				removeChild(loader);
				loader.unloadAndStop();
			}
			_content=null;
			_loader=null;
		}
		protected function get loader():Loader{
			if(_loader==null){
				loader=new Loader();
				addChild(loader);
			} 
			return _loader;
		}
		protected function set loader(value:Loader):void{
			if(_loader!=null){
			_loader.contentLoaderInfo.removeEventListener(
				Event.COMPLETE,contentLoaderInfo_completeEventHandler);
			_loader.contentLoaderInfo.removeEventListener(
				HTTPStatusEvent.HTTP_STATUS,contentLoaderInfo_httpStatusEventHandler);
			_loader.contentLoaderInfo.removeEventListener(
                Event.INIT, contentLoaderInfo_initEventHandler);
            _loader.contentLoaderInfo.removeEventListener(
                IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorEventHandler);
            _loader.contentLoaderInfo.removeEventListener(
                Event.OPEN, contentLoaderInfo_openEventHandler);
            _loader.contentLoaderInfo.removeEventListener(
                ProgressEvent.PROGRESS, contentLoaderInfo_progressEventHandler);
            _loader.contentLoaderInfo.removeEventListener(
                SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfo_securityErrorEventHandler);
            _loader.contentLoaderInfo.removeEventListener(
                Event.UNLOAD, contentLoaderInfo_unloadEventHandler);
			}
			_loader=value;
			_loader.contentLoaderInfo.addEventListener(
				Event.COMPLETE,contentLoaderInfo_completeEventHandler);
			_loader.contentLoaderInfo.addEventListener(
				HTTPStatusEvent.HTTP_STATUS,contentLoaderInfo_httpStatusEventHandler);
			_loader.contentLoaderInfo.addEventListener(
                Event.INIT, contentLoaderInfo_initEventHandler);
            _loader.contentLoaderInfo.addEventListener(
                IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorEventHandler);
            _loader.contentLoaderInfo.addEventListener(
                Event.OPEN, contentLoaderInfo_openEventHandler);
            _loader.contentLoaderInfo.addEventListener(
                ProgressEvent.PROGRESS, contentLoaderInfo_progressEventHandler);
            _loader.contentLoaderInfo.addEventListener(
                SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfo_securityErrorEventHandler);
            _loader.contentLoaderInfo.addEventListener(
                Event.UNLOAD, contentLoaderInfo_unloadEventHandler);
            addChild(loader);
		}
		protected function dispatchManual():void{
			dispatchEvent(new Event(Event.INIT));
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,0,0));
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function contentLoaderInfo_completeEventHandler(e:Event):void{
			dispatchEvent(e);
		}
		private function contentLoaderInfo_httpStatusEventHandler(e:HTTPStatusEvent):void{
			dispatchEvent(e);
		}
		private function contentLoaderInfo_initEventHandler(e:Event):void{
			dispatchEvent(e);
		}
		private function contentLoaderInfo_ioErrorEventHandler(e:IOErrorEvent):void{
			dispatchEvent(e);
		}
		private function contentLoaderInfo_openEventHandler(e:Event):void{
			dispatchEvent(e);
		}
		private function contentLoaderInfo_progressEventHandler(e:ProgressEvent):void{
			dispatchEvent(e);
		}
		private function contentLoaderInfo_securityErrorEventHandler(e:SecurityErrorEvent):void{
			dispatchEvent(e);
		}
		private function contentLoaderInfo_unloadEventHandler(e:Event):void{
			dispatchEvent(e);
		}
		public override function dispatchEvent(event:Event):Boolean{
			if(hasEventListener(event.type))
				return super.dispatchEvent(event);
			return false;
		} 
		/**
		 * 与系统Loader方法一样，可传入参数为String,URLRequest,DisplayObject,BitmapData,ByteArray 
		 * 事件发送者由contentLoaderInfo更变为本自身
		 * @param url 任意支持传入的参数
		 * @param context
		 * 
		 */		
		public function load(url:Object,context:LoaderContext = null):void{
			if(url is String){
				loader.load(new URLRequest(String(url)),context);
				return
			}else if(url is URLRequest){
				loader.load(URLRequest(url),context);
				return
			}else if(url is ByteArray){
				loader.loadBytes(ByteArray(url));
				return
			}else if(url is Loader){
				if(_loader!=url){
					reInitLoader();
					loader=url as Loader;
				}
				return
			}else{
				reInitLoader();
				if(url is DisplayObject){
					_content=url as DisplayObject;
					addChild(_content);
					dispatchManual();
				}else if(url is BitmapData){
					_content=new Bitmap(BitmapData(url));
					addChild(_content);
					dispatchManual();
				}
			}
		}
		public function get content():DisplayObject{
			return _loader!=null?_loader.content:_content;
		}
		public function unloadAndStop(gc:Boolean=true):void{
			if(_loader!=null){
				_loader.unloadAndStop(gc);
				return
			}
			if(_content!=null){
				if(_content is MovieClip){
					MovieClip(_content).stop();
					dispatchEvent(new Event(Event.UNLOAD));
					return
				}
				if(_content is Bitmap){
					Bitmap(_content).bitmapData.dispose();
					dispatchEvent(new Event(Event.UNLOAD));
					return
				}
			}
		}
		public function close():void{
			if(_loader!=null){
				_loader.close();
				return
			}
		}
		public function unload():void{
			if(_loader!=null){
				_loader.unload();
				return;
			}
			if(_content!=null){
				removeChild(_content);
				_content=null
				dispatchEvent(new Event(Event.UNLOAD));
			}
		}
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void{
			loader.loadBytes(bytes,context);
		}
	}
}
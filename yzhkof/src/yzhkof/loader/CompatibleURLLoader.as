package yzhkof.loader
{
	import com.hurlant.eval.ast.StrictEqual;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.util.EventProxy;
	import yzhkof.util.delayCallNextFrame;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="PROGRESS", type="flash.events.ProgressEvent")]
	[Event(name="io_error", type="flash.events.IOErrorEvent")]
	
	public class CompatibleURLLoader extends EventDispatcher
	{
		private var text_data:String;
		private var _url_loader:URLLoader
			
		
		public function CompatibleURLLoader()
		{
		}

		public function get dataFormat():String
		{
			return getURLLoader().dataFormat;
		}

		public function set dataFormat(value:String):void
		{
			getURLLoader().dataFormat=value;
		}

		public function load(request:Object):void{
			if(request is String){
				reInit();
				text_data=request as String;
				dispatchManual();
				return;
			}
			if(request is URLRequest){
				loadURL(request);
				return;
			}
			if(request is URLLoader){
				url_loader=request as URLLoader;
				return;
			}
			try{
				String(request);
			}catch(e:Error){
				throw new Error("CompatibleURLLoader错误："+getQualifiedClassName(request)+"不是支持的类型！");
				return;
			}
			load(String(request));
		};
		public function loadURL(url:Object):void{
			if(url is String){
				getURLLoader().load(new URLRequest(String(url)));
				return;
			}
			if(url is URLRequest){
				getURLLoader().load(URLRequest(url))
				return;
			}
			try{
				String(url);
			}catch(e:Error){
				throw new Error("CompatibleURLLoader错误："+getQualifiedClassName(url)+"不是支持的类型！");
				return;
			}
			loadURL(String(url));
		}
		public function get data():Object{
			var re_data:Object;
			if(url_loader!=null){
				re_data=url_loader.data;
			}else{
				re_data=text_data;
			}
			return re_data;
		}
		public function getURLLoader():URLLoader{
			if(url_loader==null) url_loader=new URLLoader();
			return url_loader;
		}
		private function dispatchManual():void{
			delayCallNextFrame(function():void{
				dispatchEvent(new Event(Event.OPEN));
				dispatchEvent(new Event(Event.COMPLETE));
			});
		}		
		private function set url_loader(value:URLLoader):void{
			if(_url_loader!=null){
				EventProxy.unProxy(_url_loader,this,[Event.COMPLETE,Event.OPEN,HTTPStatusEvent.HTTP_STATUS,ProgressEvent.PROGRESS,SecurityErrorEvent.SECURITY_ERROR,IOErrorEvent.IO_ERROR]);
			}
			EventProxy.proxy(value,this,[Event.COMPLETE,Event.OPEN,HTTPStatusEvent.HTTP_STATUS,ProgressEvent.PROGRESS,SecurityErrorEvent.SECURITY_ERROR,IOErrorEvent.IO_ERROR]);
			_url_loader=value;
		}
		private function get url_loader():URLLoader{
			return _url_loader;
		}
		private function reInit():void{
			text_data=null;
			if(url_loader!=null) url_loader.close();
			_url_loader=null
		}
	}
}
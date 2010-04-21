package loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XmlLoader extends EventDispatcher
	{
		private var xmlLoader:URLLoader;
		private var xmlRequest:URLRequest;
		private var xmlData:XML;                  //XML数据
		public function XmlLoader(path:String)
		{
			xmlRequest=new URLRequest(path);
			xmlLoader=new URLLoader();
			xmlLoader.load(xmlRequest);
			xmlLoader.addEventListener(Event.COMPLETE,onComplete,false,0,true);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,onError,false,0,true);
		}
		private function onComplete(e:Event):void
		{
			xmlData=XML(URLLoader(e.currentTarget).data);
			this.dispatchEvent(new Event(Event.COMPLETE));//抛出完成的事件
		}
		private function onError(e:IOErrorEvent):void
		{
			this.dispatchEvent(e);//抛出完成的事件
		}
		public function getXmlDataCopy():XML{
			return xmlData.copy();
		}
		public function dispose():void
		{
			if(xmlLoader.hasEventListener(Event.COMPLETE))
			{
				xmlLoader.removeEventListener(Event.COMPLETE,onComplete);
			}
			xmlLoader.close();
			xmlLoader=null;
			xmlRequest=null;
		}
	}
}
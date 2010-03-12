package shares.models
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XmlLoaderModel extends EventDispatcher
	{
		private var xmlLoader:URLLoader;
		private var xmlRequest:URLRequest;
		public var xmlData:XML;                  //XML数据
		public function XmlLoaderModel(path:String)
		{
			xmlRequest=new URLRequest(path);
			xmlLoader=new URLLoader(xmlRequest);
			xmlLoader.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void
		{
			xmlData=XML(URLLoader(e.currentTarget).data);
			this.dispatchEvent(new Event(Event.COMPLETE));//抛出完成的事件
		}
	}
}
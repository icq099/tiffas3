package lxfa.model
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import lxfa.utils.MemoryRecovery;
	
	public class XmlLoaderModel extends Sprite
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
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(xmlLoader,Event.COMPLETE,onComplete);
			MemoryRecovery.getInstance().gcObj(xmlLoader);
			MemoryRecovery.getInstance().gcObj(xmlRequest);
		}
	}
}
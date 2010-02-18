package lxfa.model
{
	//标准窗数据的model
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ItemModel extends Sprite
	{
		private var xmlLoader:URLLoader;
		private var xmlRequest:URLRequest;
		private const path:String="xml/item.xml";
		public var xmlData:XML;
		public function ItemModel()
		{
			xmlRequest=new URLRequest(path);
			xmlLoader=new URLLoader(xmlRequest);
			xmlLoader.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void
		{
			xmlData=XML(URLLoader(e.currentTarget).data);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
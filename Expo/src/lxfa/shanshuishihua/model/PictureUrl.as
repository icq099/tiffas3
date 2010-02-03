package lxfa.shanshuishihua.model
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class PictureUrl extends Sprite
	{
		private var xmlLoader:URLLoader;
		private var xmlRequest:URLRequest;
		private const path:String="xml/shanshishuihua.xml";
		public var xmlData:XML;
		public function PictureUrl()
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
		public function getXmlData():XML
		{
			return xmlData;
		}
		public function getPictureList():Array
		{
			
		}
		public function fuck():int
		{
			return xmlData.Items.Item.length;
		}
	}
}
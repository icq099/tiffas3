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
			return null;
		}
		//获取指定位置的图片
		public function getPictureUrl(num:int):String
		{
			return xmlData.Item[num].Picture[0];
		}
		public function getItemOfNumber():int
		{
			return xmlData.Item.length();//Item的长度
		}
		public function getVideoUrl(num:int):String
		{
			return xmlData.Item[num].Video[0];
		}
		public function getText(num:int):String
		{
			return xmlData.Item[num].Text[0];
		}
	}
}
package lxfa.shanshuishihua.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import lxfa.shanshuishihua.model.PictureUrl;
	
	public class PictureUrlCtr extends Sprite
	{
		private var pictureUrl:PictureUrl;
		public function PictureUrlCtr()
		{
			pictureUrl=new PictureUrl();
			pictureUrl.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		public function getItemOfNumber():int
		{
			return -1;
		}
	}
}
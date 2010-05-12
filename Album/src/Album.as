package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.validators.IValidatorListener;
	
	import yzhkof.BasicAsProject;
	
	[SWF(width = "650",height = "500",frameRate = "25",backgroundColor="0xffffff")]
	public class Album extends BasicAsProject
	{
		public function Album()
		{
			Mxml.Instance.addEventListener(Event.COMPLETE,__onLoadComplete);
		}
		private function init():void
		{
			addChild(new PhotoBrower());
			
		}
		private function __onLoadComplete(e:Event):void
		{
			init();
		}
	}
}
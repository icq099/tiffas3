package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import yzhkof.MyGraphy;

	public class EventTest extends Sprite
	{
		public function EventTest()
		{
			addChild(MyGraphy.drawRectangle());
			addEventListener(MouseEvent.CLICK,onMouseClick);
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		private function onMouseClick(e:Event):void{
			
			trace("click");
		
		}
		
	}
}
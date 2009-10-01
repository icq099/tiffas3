package
{
	import communication.MainSystem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import yzhkof.MyGraphy;

	public class FrameWorkTest extends MovieClip
	{
		public function FrameWorkTest()
		{
			var a:Sprite=MyGraphy.drawRectangle();
			addChild(a);
			a.addEventListener(MouseEvent.CLICK,function(e:Event):void{
				MainSystem.getInstance().runScript("gotoScene(2);");
			});
		}
	}
}
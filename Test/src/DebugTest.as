package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import yzhkof.MyGraphy;

	public class DebugTest extends Sprite
	{
		//yzhkof::debugging
		public function DebugTest()
		{
			super();
			addChild(MyGraphy.drawRectangle());
			//trace(yzhkof::debug)
			var a:MovieClip
			a.addFrameScript();

		}
		
	}
}
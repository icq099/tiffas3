package
{
	import flash.display.Sprite;
	
	import scripsimple.ScriptUtil;

	public class ZTest extends Sprite
	{
		public function ZTest()
		{
			trace(ScriptUtil.test("xx <aa <bbb> <bbb> aa> yy"));
		}
		
	}
}
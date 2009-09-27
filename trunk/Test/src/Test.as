package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import view.SubTitle;
	
	import yzhkof.BasicAsProject;

	public class Test extends BasicAsProject
	{
		private var a:Object;
		public function Test()
		{
			var a:SubTitle=new SubTitle();
			a.text="asdf;asdffsadf";
			addChild(a);
			var b:Sprite=new Sprite();
			b.scaleX=3;
			b.transform.colorTransform=new ColorTransform(0,0,0)
			a.transform=b.transform;
		}
		private function enterFrameHandler(e:MouseEvent):void{
			
			trace(a.b);
		
		}
	}
}

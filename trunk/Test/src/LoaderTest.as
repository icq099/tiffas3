package
{
	import flash.events.Event;
	
	import yzhkof.BasicAsProject;
	import yzhkof.MyGraphy;
	import yzhkof.loader.CompatibleLoader;

	public class LoaderTest extends BasicAsProject
	{
		public function LoaderTest()
		{
			var loader:CompatibleLoader=new CompatibleLoader();
			loader.load(MyGraphy.drawRectangle());
			loader.addEventListener(Event.COMPLETE,function(e:Event):void{
				trace("ok");
			});
			addChild(loader);
		}
		
	}
}
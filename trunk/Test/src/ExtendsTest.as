package
{
	import flash.display.Loader;
	import flash.events.Event;
	
	import yzhkof.BasicAsProject;
	import yzhkof.loader.CompatibleLoader;
	import yzhkof.loader.LoaderManager;

	public class ExtendsTest extends BasicAsProject
	{
		public function ExtendsTest()
		{
			/* var a:Loader=new Loader();
			a.load(new URLRequest("1.jpg"));
			a.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void{
				trace("ok");
			})
			a.unloadAndStop(); */
			test();
		}
		private function test():void{
			var a:Loader=LoaderManager.getNormalLoader("1.jpg",1);
			var b:Loader=LoaderManager.getNormalLoader("2.jpg",0);
			var c:CompatibleLoader=LoaderManager.getCompatibleLoader("3.jpg",2);
			
			a.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
				trace("a");
			})		
			b.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
				trace("b");
				/* var d:LoaderProxy=LoaderManager.getCompatibleLoader("4.jpg");
				d.addEventListener(Event.COMPLETE,function(e:Event):void{
				trace("d");
				}) */
			})	
			c.addEventListener(Event.COMPLETE,function(e:Event):void{
				trace("c");
			})	
		}
		
	}
}
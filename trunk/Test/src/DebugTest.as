package
{
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	
	import yzhkof.util.EventProxy;

	public class DebugTest extends Sprite
	{
		//yzhkof::debugging
		public function DebugTest()
		{
			var a:A=new A();
			
			this.addEventListener(ProgressEvent.PROGRESS,function(e:ProgressEvent):void{
				trace(e.bytesLoaded);
			});
			//EventProxy.proxy(a,this,[ProgressEvent.PROGRESS]);
			a.o2();

		}
		
	}
}
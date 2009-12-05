package
{
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	public class A extends EventDispatcher
	{
		public function A()
		{
		}
		public function o1():void{
			//trace("Ao1");
		}
		public function o2():void{
			o1();
			var e:ProgressEvent=new ProgressEvent(ProgressEvent.PROGRESS,false);
			e.bytesLoaded=100;
			dispatchEvent(e);
		}

	}
}
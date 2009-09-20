package
{
	import facades.FacadePv;
	
	import flash.events.Event;
	
	import mx.containers.Canvas;
	
	public class Pv360Application extends Canvas
	{
		public function Pv360Application()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
			
			
		}	
		private function init(e:Event):void{
			
			var a:FacadePv=new FacadePv();
			a.startUp(this);
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE,init);
		
		}

	}
}
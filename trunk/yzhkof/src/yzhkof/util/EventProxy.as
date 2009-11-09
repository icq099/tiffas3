package yzhkof.util
{
	import flash.events.EventDispatcher;
	
	public class EventProxy
	{
		public function EventProxy()
		{
		}
		public static function proxy(dispatcher:EventDispatcher,proxyDispatcher:EventDispatcher,event_type:Array):void{
			for each(var i:String in event_type){
				if(i!=null)
					dispatcher.addEventListener(i,proxyDispatcher.dispatchEvent);
			}
		}
		public static function unProxy(dispatcher:EventDispatcher,proxyDispatcher:EventDispatcher,event_type:Array):void{
			for each(var i:String in event_type){
				dispatcher.removeEventListener(i,proxyDispatcher.dispatchEvent);
			}
		}
	}
}
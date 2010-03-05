package yzhkof.util
{
	import flash.events.EventDispatcher;
	
	public class EventProxy
	{
		public function EventProxy()
		{
		}
		public static function proxy(dispatcher:EventDispatcher,proxyDispatcher:EventDispatcher,event_type:Array,listenerParam:Array=null):void{
			if(listenerParam==null)
				listenerParam=new Array();
			for each(var i:String in event_type){
				if(i!=null)
					dispatcher.addEventListener(i,proxyDispatcher.dispatchEvent,listenerParam[0]==undefined?false:listenerParam[0],listenerParam[1]==undefined?0:listenerParam[1],listenerParam[2]==undefined?false:listenerParam[2]);
			}
		}
		public static function unProxy(dispatcher:EventDispatcher,proxyDispatcher:EventDispatcher,event_type:Array):void{
			for each(var i:String in event_type){
				dispatcher.removeEventListener(i,proxyDispatcher.dispatchEvent);
			}
		}
	}
}
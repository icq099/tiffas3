package yzhkof.util
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public function delayCallNextFrame(dobj:DisplayObject,fun:Function):void
	{
		var fun_new:Function=function(e:Event):void{
			fun();
			dobj.removeEventListener(Event.ENTER_FRAME,fun_new);
		}
		dobj.addEventListener(Event.ENTER_FRAME,fun_new);
	}
}
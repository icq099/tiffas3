package yzhkof.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public function delayCallNextFrame(fun:Function):void
	{
		var dobj:Sprite=new Sprite();
		var fun_new:Function=function(e:Event):void{
			fun();
			dobj.removeEventListener(Event.ENTER_FRAME,fun_new);
		}
		dobj.addEventListener(Event.ENTER_FRAME,fun_new);
	}
}
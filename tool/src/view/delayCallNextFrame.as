package view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public function delayCallNextFrame(fun:Function,delay_frame:int=1):void
	{
		var dobj:Sprite=new Sprite();
		var fun_new:Function=function(e:Event):void{
			if(--delay_frame<=0){
				fun();
				dobj.removeEventListener(Event.ENTER_FRAME,fun_new);
			}
		}
		dobj.addEventListener(Event.ENTER_FRAME,fun_new);
	}
}
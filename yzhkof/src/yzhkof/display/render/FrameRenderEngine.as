package yzhkof.display.render
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FrameRenderEngine extends RenderEngineBasic
	{
		public var renderSpeedCoefficient:Number=1;
		
		private var coefficientCounter:Number=1;
		private var ticker:Sprite;
		public function FrameRenderEngine()
		{
			super();
			ticker=new Sprite();
		}
		public override function startRender():void{
			ticker.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			super.startRender();
		}
		public override function stopRender():void
		{
			ticker.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			super.stopRender();
		}
		public override function rend():void
		{
			if(coefficientCounter<=0)
			{
				super.rend();
				coefficientCounter+=1;
				if(coefficientCounter<=0)
					rend();
			}
		}
		private function onEnterFrame(e:Event):void
		{
			coefficientCounter-=renderSpeedCoefficient;
			rend();
		}
		
	}
}
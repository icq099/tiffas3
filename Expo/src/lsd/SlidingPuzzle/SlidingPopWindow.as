package lsd.SlidingPuzzle
{
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.events.SliderEvent;

	public class SlidingPopWindow extends Sprite
	{
		private var popWindow:Window;
		private var next_button:PushButton;
		private var end_button:PushButton;
		
		public function SlidingPopWindow()
		{
			init():
		}
		
		private function init():void{
			
			popWindow=new Window(this,100,100,"提示");
			popWindow.width=120
			next_button=new PushButton(popWindow,5,30,"下一关",next_fun);
			next_button.width=50;
			end_button=new PushButton(popWindow,60,30,"结束",end_fun);
			end_button.width=50;
			
		}
		
		private function next_fun(e:Event):void{
			
			dispatchEvent(new SliderEvent(SlidingEvent.PUZZLE_CHANG));
		}
		
		private function end_fun(e:Event):void{
			
			dispatchEvent(new SlidingEvent(SlidingEvent.PUZZLE_END));
		}
		
		public function dispose():void{
			
			this.removeChild(popWindow);
			this.removeChild(next_button);
			this.removeChild(end_button);
			popWindow=null;
			end_button=null
			next_button=null;
		}
		
		
	}
}
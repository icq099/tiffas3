package
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FullScreen extends Sprite
	{
		public function FullScreen()
		{
			stage.addEventListener(MouseEvent.CLICK,function(e:Event):void{
				stage.displayState=StageDisplayState.FULL_SCREEN;
			});
		}
		
	}
}
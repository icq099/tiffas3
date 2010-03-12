package core.view
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class ExpoApplicaion extends Sprite
	{
		public function ExpoApplicaion()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,ADDED_TO_STAGE);
		}
		private function ADDED_TO_STAGE(e:Event):void
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
		}
	}
}
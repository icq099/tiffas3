package yzhkof
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import yzhkof.core.StageManager;
	
	public class BasicAsProject extends Sprite
	{		
		private static var _stage:Stage;
		
		public function BasicAsProject()
		{
			this.stage.align=StageAlign.TOP_LEFT;
			this.stage.scaleMode=StageScaleMode.NO_SCALE;
			_stage=this.stage;
			StageManager.init(_stage);
		}
		public static function get stage():Stage{
			
			return _stage;
		}

	}
}
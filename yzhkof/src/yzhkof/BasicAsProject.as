package yzhkof
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class BasicAsProject extends Sprite
	{		
		private static var _stage:Stage;
		
		public function BasicAsProject()
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
		}
		protected static function set mainStage(value:Stage):void{
			
			_stage=value;
		
		}
		public static function get mainStage():Stage{
			
			return _stage;
		
		}

	}
}
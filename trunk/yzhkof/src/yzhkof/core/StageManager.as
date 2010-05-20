package yzhkof.core
{
	import flash.display.Stage;

	public class StageManager
	{
		public function StageManager()
		{
		}
		private static var _stage:Stage;
		public static function init(stage:Stage):void
		{
			_stage=stage
		}

		public static function get stage():Stage
		{
			return _stage;
		}

	}
}
package yzhkof
{
	import flash.display.Sprite;
	
	import yzhkof.debug.DebugSystem;
	
	public class DebugAsProject extends BasicAsProject
	{
		public function DebugAsProject()
		{
			super();
			DebugSystem.init(this);
		}
	}
}
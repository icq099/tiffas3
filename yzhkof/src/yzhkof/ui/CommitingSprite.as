package yzhkof.ui
{
	public class CommitingSprite extends DelayRendSprite
	{
		protected var changes:Object;
		/**
		 * 设置是否自动重绘，布局 
		 */		
		public var autoDraw:Boolean = true;
		
		public function CommitingSprite()
		{
			super();
			init();
		}
		private function init():void
		{
			changes = new Object;
		}
		protected function commitChage(changeThing:String = "default_change"):void
		{
			changes[changeThing] = (hasOwnProperty(changeThing)&&this[changeThing])||null;
			autoDraw&&upDateNextRend();
		}
		override protected function beforDraw():void
		{
			
		}
		override protected function afterDraw():void
		{
			changes = new Object;
		}
	}
}
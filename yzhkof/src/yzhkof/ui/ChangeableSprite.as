package yzhkof.ui
{
	public class ChangeableSprite extends DelayRendSprite
	{
//		protected var _lastPropertyValue:Object;
//		protected var _changeCount:uint = 0;
		
		public function ChangeableSprite()
		{
			super();
		}
		protected function commitChage(changeProperty:String = ""):void
		{
//			if(_lastPropertyValue == null) 
//			{
//				_lastPropertyValue = {};
//				_changeCount ++;
//			}
//			if(changeProperty)
//			{
//				if(_lastPropertyValue.hasOwnProperty(changeProperty))
//				{
//					_lastPropertyValue[changeProperty] = this[changeProperty];
//				};
//				if(_lastPropertyValue[changeProperty] == this[changeProperty])
//				{
//					_changeCount--;
//					if(_changeCount <= 0)
//					{
//						cancelUpDataNextRend();
//					}
//					return;
//				}
//			}
//			_changeCount ++;
			upDateNextRend();
		}
//		private function recordChanges():void
//		{
//			if(_lastPropertyValue == null) return;
//			for (var i:String in _lastPropertyValue)
//			{
//				_lastPropertyValue[i] = this[i];	
//			}
//		}
//		override protected function afterDraw():void
//		{
//			super.afterDraw();
//			recordChanges();
//		}
//		override protected function cancelUpDataNextRend():void
//		{
//			super.cancelUpDataNextRend();
//			_changeCount = 0;
//		}
	}
}
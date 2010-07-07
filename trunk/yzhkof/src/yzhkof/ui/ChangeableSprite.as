package yzhkof.ui
{
	public class ChangeableSprite extends DelayRendSprite
	{
		protected var _lastPropertyValue:Object = {};
		protected var _changeablePropertys:Array = [];
		protected var _changeableThings:Array = ["default_change"];
		protected var _changes:Object = {};
		
		public function ChangeableSprite()
		{
			super();
			initChangeables();
			initChanges();
		}
		protected function initChangeables():void
		{
			
		}
		private function initChanges():void
		{
			for each(var i:String in _changeablePropertys)
			{
				_lastPropertyValue[i] = this[i];
			}
		}
		protected final function registChangeableThings(name:String,isProperty:Boolean = true):void
		{
			if(isProperty)
			{
				_changeablePropertys.push(name);
			}
			else
			{
				_changeableThings.push(name);
			}
		}
		protected function commitChage(changeThing:String = "default_change"):void
		{
			_changes[changeThing] = true;
			upDateNextRend();
		}
		override protected function beforDraw():void
		{
			if(!checkCanDraw())
				cancelCurrentRend();
		}
		override protected function afterDraw():void
		{
			recordChangeablePropertys();
		}
		private function recordChangeablePropertys():void
		{
			for(var i:String in _changes)
			{
				if(_changeableThings.indexOf(i)>=0) continue;
				_lastPropertyValue[i] = this[i];
			}
		}
		private function checkCanDraw():Boolean
		{
			for(var i:String in _changes)
			{
				if(_changeableThings.indexOf(i)>=0) return true;
				if(_lastPropertyValue[i] != this[i]) return true;
			}
			return false;
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
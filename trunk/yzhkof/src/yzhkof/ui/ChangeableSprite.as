package yzhkof.ui
{
	public class ChangeableSprite extends DelayRendSprite
	{
		protected var _lastPropertyValue:Object = {};
		/**
		 * 可以改变的属性(如果有属性跟上次屏幕渲染时的不一样，则调用onDraw方法) 
		 */		
		protected var _changeablePropertys:Array = [];
		/**
		 * 可以改变的东西(只要这里面记录的东西有commitChange，不管属性跟上次渲染一不一样都调用onDraw)
		 */		
		protected var _changeableThings:Array = [DEFAULT_CHANGE];
		/**
		 * 记录当前的改变 
		 */		
		protected var _changes:Object = {};
		public static const DEFAULT_CHANGE:String = "default_change";
		
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
				if(_changes[i])
				{
					if(_changeableThings.indexOf(i)>=0) 
					{
						_changes[i] = false;
						continue;
					}
					_lastPropertyValue[i] = this[i];
					_changes[i] = false;
				}
			}
		}
		private function checkCanDraw():Boolean
		{
			for(var i:String in _changes)
			{
				if(_changes[i])
				{
					if(_changeableThings.indexOf(i)>=0) return true;
					if(_lastPropertyValue[i] != this[i]) return true;
				}
			}
			return false;
		}
	}
}
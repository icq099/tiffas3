package swfguarder
{
	public class CallBacker
	{
		private var _listeners:Array = [];
		private var _singleListeners:Array = [];
		private var _target:Object;

		private var _data:*;
		
		public var userData:*;
		
		public function CallBacker(target:Object = null)
		{
			_target = target||this;
		}
		public function addListener(listener:Function):void
		{
			if(_listeners.indexOf(listener)<0)
				_listeners.push(listener);
		}
		public function removeListener(listener:Function):void
		{
			var index:int = _listeners.indexOf(listener);
			if(index<0) return;
			_listeners.splice(index,1);
			index = _singleListeners.indexOf(listener);
			if(index>=0)
			{
				_singleListeners.splice(index,1);
			}
		}
		public function dispatch(data:* = null):void
		{
			_data = data;
			var callBacks:Array = new Array().concat(_listeners);//安全起见，clone一份;
			for each (var i:Function in callBacks) 
			{
				
				if(i.length == 1)
					i(this);
				else
					i();
				
				var index:int = _singleListeners.indexOf(i);
				if(index>=0)
				{
					removeListener(i);
				}
			}
		}
		/**
		 * 触发一次的监听，触发后自动remove; 
		 * @param listener
		 * 
		 */		
		public function addSingleListener(listener:Function):void
		{
			if(_singleListeners.indexOf(listener)<0)
			{
				_singleListeners.push(listener);
				addListener(listener);
			}
		}
		public function removeAllListeners():void
		{
			_listeners = [];
			_singleListeners = [];
		}
		public function get target():Object
		{
			return _target;
		}
		public function get listenerLength():int
		{
			return _listeners.length;
		}
		public function get data():*
		{
			return _data;
		}


	}
}
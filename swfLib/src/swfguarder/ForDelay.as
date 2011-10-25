package swfguarder
{
	import yzhkof.util.Helpers;

	public class ForDelay
	{

		private var _start_i:int;
		private var _for_count:int;
		private var _for_size:int;
		private var _for_fun:Function;
		
		private var _currentIndex:int;
		
		public function ForDelay(for_count:int , for_fun:Function , start_i:int = 0 ,for_size:int = 100)
		{
			_start_i = start_i;
			_for_count = for_count;
			_for_size = for_size;
			_for_fun = for_fun;
			initFor();
		}
		
		private function initFor():void
		{
			var for_to:int = _currentIndex + _for_size;
			if(for_to >= (_start_i + _for_count))
			{
				for_to = _start_i + _for_count;
			}
			for (var i:int = _currentIndex; i < for_to; i++) 
			{
				_for_fun(i);
			}
			
			_currentIndex = i;
			
			if(for_to >= (_start_i + _for_count))
			{
				return;
			}
			
			Helpers.delayCall(initFor);
		}
		
	}
}
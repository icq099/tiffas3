package yzhkof
{
	import flash.utils.getTimer;
	
	public class EfficiencyTestor
	{
		
		private static var _start_time:int=0;
		
		public function EfficiencyTestor()
		{
		}
		public static function start():void{
			
			_start_time=getTimer();
		
		}
		public static function result():int{
			
			return getTimer()-_start_time;
		
		}
		public static function resultFormat():String{
			
			return result()/1000+"秒";
		
		}
		public static function efficiencyOfFunction(fun:Function):void{
			
			start();
			fun();
		
		}
		public static function efficiencyOfFunctionTrace(fun:Function,ifTrace:Boolean=true):int{
			
			efficiencyOfFunction(fun);
			ifTrace?trace(result()):null;
			return result();
		
		}
		public static function efficiencyOfFunctionTraceFormat(fun:Function,ifTrace:Boolean=true):String{
			
			efficiencyOfFunction(fun);
			ifTrace?trace(resultFormat()):null;
			return resultFormat();
		
		}

	}
}
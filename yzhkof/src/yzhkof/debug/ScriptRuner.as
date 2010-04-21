package yzhkof.debug
{
	import com.hurlant.eval.ByteLoader;
	import com.hurlant.eval.CompiledESC;
	
	import flash.utils.ByteArray;
	
	import yzhkof.util.WeakMap;
	public class ScriptRuner
	{
		private static var runer:CompiledESC;
		private static var weakTarget:WeakMap=new WeakMap();
		public static function init():void
		{
			if(!runer)
				runer=new CompiledESC();
		}
		public static function run(script:String):void
		{
			var final_script:String="namespace fu = \"yzhkof.debug\"; use namespace fu;";
			final_script+=script;
			var byte:ByteArray=runer.eval(final_script);
			ByteLoader.loadBytes(byte);
		}
		public static function set target(value:Object):void
		{
			weakTarget=new WeakMap();
			weakTarget.add(0,value);
		}
		public static function get target():Object
		{
			return weakTarget.getValue(0);
		}
		public static function getDefinitionByName(value:String):*
		{
			return getDefinitionByName(value);	
		}
		public static function trace(obj:Object,showFunctionReturn:Boolean=false):void
		{
			traceObject(obj,showFunctionReturn);
		}

	}
}
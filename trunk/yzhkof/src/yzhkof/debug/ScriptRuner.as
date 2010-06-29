package yzhkof.debug
{
	import com.hurlant.eval.ByteLoader;
	import com.hurlant.eval.CompiledESC;
	import com.hurlant.eval.ast.StrictEqual;
	import com.hurlant.util.Hex;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	
	import yzhkof.loader.CompatibleURLLoader;
	import yzhkof.util.WeakMap;

	public class ScriptRuner
	{
		private static var runer:CompiledESC;
		private static var weakTarget:WeakMap=new WeakMap();
		private static var xml:XML;
		private static var import_text:String="";
		
		public static function init():void
		{
			if(!runer)
				runer=new CompiledESC();
			var loader:CompatibleURLLoader=new CompatibleURLLoader();
			loader.loadURL("xml/debugConfig.xml");
			loader.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				xml=XML(loader.data);
				analyseXml();
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void
			{
				trace("debug config fail!");
			});
		}
		private static function analyseXml():void
		{
			var length:uint=xml.import_namespace.length();
			import_text="";
			for(var i:int=0;i<length;i++)
			{
				import_text+="namespace xmlu"+i+" = \""+xml.import_namespace[i]+"\"; use namespace xmlu"+i+";\n";
			}
		}
		public static function run(script:String):void
		{
			var final_script:String=import_text+"namespace xmlud = \"yzhkof.debug\"; use namespace xmlud;\n";
			final_script+=script;
			var byte:ByteArray=runer.eval(final_script);
			traceObject(Hex.dump(byte));
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
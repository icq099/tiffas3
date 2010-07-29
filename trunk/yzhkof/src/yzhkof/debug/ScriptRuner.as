package yzhkof.debug
{
	import com.hurlant.eval.ByteLoader;
	import com.hurlant.eval.CompiledESC;
	import com.hurlant.eval.ast.StrictEqual;
	import com.hurlant.util.Hex;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import yzhkof.loader.CompatibleURLLoader;
	import yzhkof.logicdata.ScriptRun;
	import yzhkof.util.WeakMap;

	public class ScriptRuner
	{
		private static var runer:CompiledESC;
		private static var weakTarget:WeakMap=new WeakMap();
		private static var xml:XML;
		private static var import_text:String="";
		public static var global:Object;
		
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
			import_text += "namespace xmlud = \"yzhkof.debug\"; use namespace xmlud;\n";
		}
		public static function run(script:String):void
		{
			var final_script:String=import_text;
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
		public static function trace(obj:Object):void
		{
			debugObjectTrace(obj);
		}
		public static function runScript(url:String):ScriptRun
		{
			var logic:ScriptRun = new ScriptRun;
			var urlloader:URLLoader = new URLLoader(new URLRequest(url));
			var loader:Loader = new Loader();
			var byte:ByteArray;
			var script:String;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				logic.dispatchEvent(new Event(Event.COMPLETE));
			});
			logic.urlLoader = urlloader;
			logic.loader = loader;
			script = import_text;
			urlloader.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				script += urlloader.data as String;
				script += tailText;
				script = convertImport(script);
				byte = runer.eval(script);
				byte = ByteLoader.wrapInSWF([byte]);
				logic.script = script;
				logic.bytes = byte;
				loader.loadBytes(byte);
			});
			return logic;
		}
		/**
		 * import 转换处理 
		 * @param e
		 * 
		 */		
		private static function convertImport(str:String):String
		{
			var reg:RegExp = new RegExp("import.*","g");
			var result_arr:Array = str.match(reg);
			for each(var i:String in result_arr)
			{
				str = str.replace(i,getImport(getPackage(i)));
				importCount++;
			}
			return str;
		}
		private static var importCount:int = 0;
		private static function getPackage(str:String):String
		{
			var reg:RegExp = new RegExp(" .*\\.");
			var t_str:String = str.match(reg)[0];
			return t_str.substring(1,t_str.length-1);
		}
		private static function getImport(str:String):String
		{
			return "namespace importn"+importCount+" = \""+str+"\"; use namespace importn"+importCount+";\n"
		}
		private static const tailText:String = ";ScriptRuner.global = this";
	}
}
package yzhkof.debug
{
	import com.hurlant.eval.ByteLoader;
	import com.hurlant.eval.CompiledESC;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
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
		private static var script_xml:XMLList;
		private static var import_text:String="";
		
		private static const CONFIG_XML_URL:String = "../resource/debugConfig.xml";
		public static var global:Object;
		
		public static function init():void
		{
			if(!runer)
				runer=new CompiledESC();
			var loader:CompatibleURLLoader=new CompatibleURLLoader();
			loader.loadURL(CONFIG_XML_URL);
			loader.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				xml=XML(loader.data);
				analyseXml();
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void
			{
				trace("debug config fail! at \"" + CONFIG_XML_URL + "\"");
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
			
			script_xml = xml.script;
			reFreshScript();
		}
		public static function run(script:String):void
		{
			var final_script:String=import_text;
			final_script+= convertImport(script);
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
		/**
		 * 运行一个异步脚本 
		 * @param url 脚本路径
		 * @return 
		 * 
		 */		
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
		private static var scripts:Object = new Object;
		/**
		 * 运行一个已编译好的脚本 
		 * @param name
		 * @param param
		 * @param refresh
		 * @return 
		 * 
		 */		
		public static function runScriptSynchronous(name:String,param:Array,refresh:Boolean = false):*
		{
			if(refresh)
				reFreshScript();
			var script:Object = scripts[name];
			if(!script)
				throw new Error("脚本名字错误!");
			return script.run.apply(null,param);
		}
		/**
		 * 刷新所有script文件 
		 * 
		 */		
		public static function reFreshScript():void
		{
			var length:uint = script_xml.length();
			for each(var i:XML in script_xml)
			{
				loadScript(i,i.@name);
			}
		}
		/**
		 * 刷新单个script文件 
		 * @param url
		 * @param name
		 * 
		 */		
		public static function loadScript(url:String,name:String = null):void
		{
			var urlloader:URLLoader = new URLLoader(new URLRequest(url));
			var loader:Loader = new Loader();
			var byte:ByteArray;
			var script:String;
			name = name||url;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
			{
			});
			script = import_text;
			urlloader.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				script += urlloader.data as String;
				script += ";ScriptRuner.addScript(this,\""+name+"\");";
				script = convertImport(script);
				byte = runer.eval(script);
				byte = ByteLoader.wrapInSWF([byte]);
				loader.loadBytes(byte);
			});
		}
		public static function addScript(script_point:Object,name:String):void
		{
			scripts[name] = script_point;
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
		/*******************************************************************************/
		private static const tailText:String = ";ScriptRuner.global = this";
//		private static const addScriptTailText:String = ";ScriptRuner.addScript(this);";
	}
}
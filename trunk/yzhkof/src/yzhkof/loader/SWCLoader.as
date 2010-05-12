package yzhkof.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import nochump.util.zip.ZipFile;
	
	import yzhkof.loader.event.SWCLoaderEvent;
	
	public class SWCLoader extends EventDispatcher
	{
		private var urlloader:CompatibleURLLoader;
		private var loader:CompatibleLoader;
		private var loaderContext:LoaderContext;
		private var zip_file:ZipFile;
		private var autoAttachToDomain:Boolean;
		
		private var _library:ByteArray;
		private var _catalog_xml:XML;
		
		public function SWCLoader()
		{
			
		}
		public function load(url:String,autoAttachToDomain:Boolean=true,loaderContext:LoaderContext=null):void
		{
			this.loaderContext=loaderContext;
			this.autoAttachToDomain=autoAttachToDomain;
			urlloader=new CompatibleURLLoader;
			urlloader.dataFormat=URLLoaderDataFormat.BINARY;
			urlloader.loadURL(url);
			urlloader.addEventListener(Event.COMPLETE,__onDataLoadComplete);
		}
		public function attachLibraryToDomain():void
		{
			loader=new CompatibleLoader;
			loader.load(_library,loaderContext);
			loader.addEventListener(Event.COMPLETE,__libraryLoadComplete);
		}
		private function __libraryLoadComplete(e:Event):void
		{
			dispatchEvent(new SWCLoaderEvent(SWCLoaderEvent.LIBRARY_ATTACH_COMPLETE));
		}
		private function __onDataLoadComplete(e:Event):void
		{
			zip_file=new ZipFile(ByteArray(urlloader.data));
			_library=zip_file.getInput(zip_file.getEntry("library.swf"));
			_catalog_xml=new XML(zip_file.getInput(zip_file.getEntry("catalog.xml")));
			
			if(autoAttachToDomain)
			{
				attachLibraryToDomain();
			}
		}

		public function get library():ByteArray
		{
			return _library;
		}

	}
}
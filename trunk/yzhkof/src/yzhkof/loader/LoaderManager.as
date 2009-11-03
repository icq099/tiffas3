package yzhkof.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class LoaderManager
	{
		public static const LOADER:String="Loader";
		public static const COMPATIBLELOADER:String="CompatibleLoader";
		
		private static var loader_map:Dictionary=new Dictionary(true);
		private static var group_arr:LoaderArray=new LoaderArray();
		public function LoaderManager()
		{
		}
		private static function add(url:*,loader:Object):void{
			loader_map[url]=loader;
			/* 
			if(autoRemove){
				var com_fun:Function=function(e:Event):void{
					delete loader_map[url];
				};
				if(loader is CompatibleLoader){
					loader.addEventListener(Event.COMPLETE,com_fun);
					return;
				}
				if(loader is Loader){
					Loader(loader).contentLoaderInfo.addEventListener(Event.COMPLETE,com_fun);
					return;
				}
			} */
		}
		public static function getLoader(url:String,type:String="Loader",autoLoad:Boolean=true):Object{
			if(loader_map[url]!=undefined){
				return loader_map[url]
			}else{
				var loader:Object;
				if(type==LOADER){
					loader=new Loader();
					if(autoLoad) loader.load(new URLRequest(url));
				}else if(type==COMPATIBLELOADER){
					loader=new CompatibleLoader();
					if(autoLoad) CompatibleLoader(loader).load(url);
				}
				add(url,loader,autoRemove);
				return loader;
			}
		}
		public static function getCompatibleLoader(url:String,autoLoad:Boolean=true):CompatibleLoader{
			return getLoader(url,COMPATIBLELOADER,autoLoad,autoRemove) as CompatibleLoader;
		}
		public static function getNormalLoader(url:String,autoLoad:Boolean=true):Loader{
			return getLoader(url,LOADER,autoLoad,autoRemove) as Loader;
		}
	}
}
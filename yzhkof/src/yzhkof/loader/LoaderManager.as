package yzhkof.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	
	public class LoaderManager
	{
		public static const LOADER:String="Loader";
		public static const COMPATIBLELOADER:String="CompatibleLoader";
		
		private static var loader_map:Object=new Object();
		public function LoaderManager()
		{
		}
		private static function add(url:*,loader:Object,autoRemove:Boolean=true):void{
			loader_map[url]=loader;
			if(autoRemove){
				loader.loaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
					delete loader_map[url];
				});
			}
		}
		public static function getLoader(url:*,type:String="Loader",autoLoad:Boolean=false,autoRemove:Boolean=true):Object{
			if(loader_map[url]!=undefined){
				return loader_map[url]
			}else{
				var loader:Object;
				if(type==LOADER){
					loader=new Loader();
					if(autoLoad) loader.load(url);
				}else if(type==COMPATIBLELOADER){
					loader=new CompatibleLoader();
					if(autoLoad) CompatibleLoader(loader).load(url);
				}
				add(url,loader,autoRemove);
				return loader;
			}
		}
		public static function getCompatibleLoader(url:*,autoLoad:Boolean=false,autoRemove:Boolean=true):CompatibleLoader{
			return getLoader(url,COMPATIBLELOADER,autoLoad,autoRemove) as CompatibleLoader;
		}
		public static function getNormalLoader(url:*,autoLoad:Boolean=false,autoRemove:Boolean=true):Loader{
			return getLoader(url,LOADER,autoLoad,autoRemove) as Loader;
		}
	}
}
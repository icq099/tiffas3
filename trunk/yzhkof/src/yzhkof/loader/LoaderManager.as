package yzhkof.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	
	public class LoaderManager
	{
		public static const LOADER:String="Loader";
		public static const COMPATIBLELOADER:String="CompatibleLoader";
		
		private static var currentLoadRank:int=0;
		private static var loader_map:LoaderMap=new LoaderMap();
		private static var rank_arr:Array=new Array(new Array());
		
		public function LoaderManager()
		{
		}
		private static function add(url:Object,loader:LoaderBase,autoRemove:Boolean=true):void{
			loader_map.put(url,loader);
			if(autoRemove){
				var com_fun:Function=function(e:Event):void{
					removeLoader(url);
					if(rank_arr[loader.rank].length<=0){
						if(currentLoadRank==loader.rank){
							loadNextRank();
						}
					}
				};
				loader.addEventListener(Event.COMPLETE,com_fun);
			};
		}
		private static function setRank(url:Object,rank:int=0):void{
			if(rank_arr[rank]==undefined) rank_arr[rank]=new Array();
			rank_arr[rank].push(url);
			//如果当前loadrank 大于等于 新设的loader的rank
			if(currentLoadRank>rank){
				loadRank(rank);
				return
			}
			if(currentLoadRank<rank)
				if(rank_arr[currentLoadRank].length<=0)
					loadNextRank();
		}
		private static function loadRank(rank:int):void{
			if(rank_arr[rank]==undefined) rank_arr[rank]=new Array();
			if(rank_arr[rank].length>0){
				for(var i:int=rank+1;i<rank_arr.length;i++){
					if(rank_arr[i]!=undefined){
						for each(var j:Object in rank_arr[i]){
							loader_map.getLoaderBase(j).pause();
						}
					}
				}
				for each(var k:Object in rank_arr[rank]){
					loader_map.getLoaderBase(k).resume();
				}
				currentLoadRank=rank;
			}else{
				loadNextRank();
			}
		}
		private static function loadNextRank():void{
			if(currentLoadRank<rank_arr.length-1){
				loadRank(++currentLoadRank);
			}
		}
		public static function getLoader(url:Object,rank:int=0,type:String="Loader",autoRemove:Boolean=true):Object{

			if(loader_map.getLoaderBase(url)!=null){
				return loader_map.getLoaderBase(url).loader;
			}else{
				var loader:LoaderBase;
				if(type==LOADER){
					loader=new NormalLoaderItem();
					if(currentLoadRank>=rank) loader.start(url);
				}else if(type==COMPATIBLELOADER){
					loader=new CompatibleLoaderItem();
					if(currentLoadRank>=rank) loader.start(url);
				}
				loader.rank=rank;
				loader.url=url;
				add(url,loader,autoRemove);
				setRank(url,rank);
				return loader.loader;
			}
		}
		public static function getCompatibleLoader(url:Object,rank:int=0,autoRemove:Boolean=true):CompatibleLoader{
			return getLoader(url,rank,COMPATIBLELOADER,autoRemove) as CompatibleLoader;
		}
		public static function getNormalLoader(url:String,rank:int=0,autoRemove:Boolean=true):Loader{
			return getLoader(url,rank,LOADER,autoRemove) as Loader;
		}
		public static function removeLoader(url:Object):void{
			loader_map.remove(url);
			for each(var i:Array in rank_arr){
				var index:int=i.indexOf(url);
				if(index>=0) i.splice(index,1);
			}
		}
	}
}
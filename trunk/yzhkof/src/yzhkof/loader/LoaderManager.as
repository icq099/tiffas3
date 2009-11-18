package yzhkof.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	
	import yzhkof.loader.proxy.IManageLoader;
	
	public class LoaderManager
	{
		public static const LOADER_ITEM:Class=NormalLoaderItem;
		public static const COMPATIBLELOADER_ITEM:Class=CompatibleLoaderItem;
		
		private static var currentLoadRank:int=0;
		private static var loader_map:LoaderMap=new LoaderMap();
		/**
		 * 二维数组
		 * y:rank,x:url
		 * rank1:url1,url2
		 * rank21:url3,url4
		 * rank3:url5,url5
		 */		
		private static var rank_arr:Array=new Array(new Array());
		
		public function LoaderManager()
		{
		}
		private static function add(url:Object,loader:LoaderBaseItem,autoRemove:Boolean=true):void{
			loader_map.put(url,loader);
			if(autoRemove){
				var com_fun:Function=function(e:Event):void{
					loader.removeEventListener(LoaderEvent.NEXT_STEP,com_fun);
					removeLoader(url);
					if(rank_arr[loader.rank].length<=0){
						if(currentLoadRank==loader.rank){
							loadNextRank();
						}
					}
				};
				loader.addEventListener(LoaderEvent.NEXT_STEP,com_fun);
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
				var loader_item:LoaderBaseItem
				for(var i:int=rank+1;i<rank_arr.length;i++){
					if(rank_arr[i]!=undefined){
						for each(var j:Object in rank_arr[i]){
							loader_item=loader_map.getLoaderBase(j);
							if(loader_item.isLoading) loader_item.pause();
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
		/**
		 *  
		 * @param url 地址或数据key
		 * @param type loaderitem类类型
		 * @param rank 加载等级
		 * @param autoRemove 
		 * @return 
		 * 
		 */		
		public static function getLoader(url:Object,type:Class,rank:int=0,autoRemove:Boolean=true):IManageLoader{

			if(loader_map.getLoaderBase(url)!=null){
				var re_loader:LoaderBaseItem=loader_map.getLoaderBase(url);
				if(re_loader.rank!=rank)
					setRank(url,rank);
				return re_loader.loader
			}else{
				var loader:LoaderBaseItem=new type();
				if(currentLoadRank>=rank) loader.start(url);
				/* if(type==LOADER){
					loader=new NormalLoaderItem();
					if(currentLoadRank>=rank) loader.start(url);
				}else if(type==COMPATIBLELOADER){
					loader=new CompatibleLoaderItem();
					if(currentLoadRank>=rank) loader.start(url);
				} */
				loader.rank=rank;
				loader.url=url;
				add(url,loader,autoRemove);
				setRank(url,rank);
				return loader.loader;
			}
		}
		public static function getCompatibleLoader(url:Object,rank:int=0,autoRemove:Boolean=true):CompatibleLoader{
			return getLoader(url,COMPATIBLELOADER_ITEM,rank,autoRemove) as CompatibleLoader;
		}
		public static function getNormalLoader(url:String,rank:int=0,autoRemove:Boolean=true):Loader{
			return getLoader(url,LOADER_ITEM,rank,autoRemove) as Loader;
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
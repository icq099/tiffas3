package yzhkof.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import yzhkof.util.DualMap;
	[Event(name="complete", type="flash.events.Event")]
	public class SerialLoaderBase extends EventDispatcher
	{
		protected var LoaderClass:Class;
		protected var loadFunction:String;
		protected var eventDispatcher:String;
		protected var completeEvent:String;
		protected var unLoadFunction:String;
		protected var loaderContentProperty:String;
		protected var loadParam:Array;
		
		protected var url_arr:Array=new Array();//记录要load的url
		protected var item_map:Dictionary=new Dictionary();//储存所有加载的内容,非loader
		protected var loader_url_map:DualMap=new DualMap();//url<->loader的map
		protected var complete_count:int=0;
		
		public function SerialLoaderBase(loaderClass:Class,loadFunction:String=null,eventDispatcher:String=null,completeEvent:String=null,unLoadFunction:String=null,loaderContentProperty:String=null,loadParam:Array=null)
		{
			LoaderClass=loaderClass;
			this.loadFunction=loadFunction;
			this.eventDispatcher=eventDispatcher;
			this.completeEvent=completeEvent;
			this.unLoadFunction=unLoadFunction;
			this.loaderContentProperty=loaderContentProperty;
			this.loadParam=loadParam;
		}
		/**
		 * 添加loader实例 
		 * @param url
		 * 
		 */		
		public function add(url:Object):void{
			url_arr.unshift(url);
			loader_url_map.put(url,new LoaderClass());
		}
		public function getItem(url:Object):Object{
			return item_map[url]
		}
		public function getLoader(url:Object):Object{
			return loader_url_map.getValue(url);
		}
		/**
		 * 仅仅停止loader，如需完全清除要执行clear();
		 *  
		 */		
		public function stopAll():void{
			if(unLoadFunction!=null)
				for(var i:int=0;i<url_arr.length;i++){
					var loader:Object=getLoader(url_arr[i]);
						loader[unLoadFunction]();
				}
		}
		/**
		 * 清楚所有加载项目 
		 * 
		 */		
		public function clear():void{
			stopAll();
			item_map=new Dictionary();
			url_arr=new Array();
		}
		/**
		 * 开始加载 
		 * 
		 */		
		public function start():void{
			for(var i:int=0;i<url_arr.length;i++){
				var loader:Object=getLoader(url_arr[i]);
				if(loadFunction!=null){
					if(loadParam==null)
					{
						loader[loadFunction](url_arr[i]);
					}else
					{
						var param:Array=[url_arr[i]];
						param=param.concat(loadParam)
						loader[loadFunction].apply(null,param);
					}
				}
				if(eventDispatcher!=null){
					loader[eventDispatcher].addEventListener(completeEvent,onLoaderComplete);
				}else{
					loader.addEventListener(completeEvent,onLoaderComplete);
				}
			}
		}
		/**
		 * 当有loader完成时执行一次，当所有loader完成发出event.complete事件 
		 * @param e
		 * 
		 */		
		protected function onLoaderComplete(e:Event):void{
			complete_count+=1;
			item_map[loader_url_map.getKey(e.currentTarget)]=e.currentTarget[loaderContentProperty];
			if(complete_count>=url_arr.length){
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}
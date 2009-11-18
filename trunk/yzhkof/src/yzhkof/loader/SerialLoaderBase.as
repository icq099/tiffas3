package yzhkof.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import yzhkof.util.DualMap;

	public class SerialLoaderBase extends EventDispatcher
	{
		protected var LoaderClass:Class;
		protected var url_arr:Array=new Array();
		protected var item_map:Dictionary=new Dictionary();
		protected var loader_url_map:DualMap=new DualMap();
		protected var complete_count:int=0;
		
		public function SerialLoaderBase(loaderClass:Class)
		{
			LoaderClass=loaderClass;
		}
		public function add(url:Object):void{
			url_arr.push(url);
			loader_url_map.put(url,new LoaderClass());
		}
		public function getItem(url:Object):Object{
			return item_map[url]
		}
		/**
		 * must override 
		 * 
		 */		
		public function stopAll():void{
			
		}
		public function clear():void{
			stopAll();
			item_map=new Dictionary();
			url_arr=new Array();
		}
		public function start():void{
			
		}
		protected function onLoaderComplete(e:Event):void{
			complete_count+=1;
			if(complete_count>=url_arr.length){
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}
package yzhkof.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import yzhkof.loader.proxy.IManageLoader;

[Event(name="next_step", type="yzhkof.loader.LoaderEvent")]
	public class LoaderBaseItem extends EventDispatcher
	{
		protected var _isLoading:Boolean=false;
		protected var _loader:IManageLoader;
		protected var _isComplete:Boolean=false;
		protected var _url:Object;
		protected var _rank:int=0;
		
		public function LoaderBaseItem(loader:IManageLoader)
		{
			_loader=loader;
			_loader.addEventListener(LoaderEvent.NEXT_STEP,onNextStep);
		}
		public function get isLoading():Boolean{
			return _isLoading;
		}
		public function get loader():IManageLoader{
			return _loader;
		}
		public function get isComplete():Boolean{
			return _isComplete;
		}
		public function get rank():int{
			return _rank;
		}
		public function set rank(value:int):void{
			_rank=value;
		}
		internal function set url(url:Object):void{
			_url=url;
		}
		/**
		 * override 
		 * @param value
		 * 
		 */		
		public function start(value:Object=null):void{
			_isLoading=true;
			_isComplete=false;
			_url=value;
		}
		/**
		 * override 
		 * @param value
		 * 
		 */	
		public function pause():void{
			if(!_isComplete) _isLoading=false;
		}
		/**
		 * override 
		 * @param value
		 * 
		 */	
		public function resume():void{
			if(!_isComplete) _isLoading=true;
		}
		/**
		 * override 
		 * @param value
		 * 
		 */	
		public function unload():void{
			_isComplete=false;
			_isLoading=false;
		}
		/**
		 * override 
		 * @param value
		 * 
		 */	
		public function unLoadAndStop(gc:Boolean=true):void{
			_isComplete=false;
			_isLoading=false;
		}
		protected function onNextStep(e:Event):void{
			_isLoading=false;
			_isComplete=true;
			dispatchEvent(new Event(LoaderEvent.NEXT_STEP));
		}
	}
}
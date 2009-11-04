package yzhkof.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

[Event(name="complete", type="flash.events.Event")]
	public class LoaderBase extends EventDispatcher
	{
		protected var _isLoading:Boolean=false;
		protected var _loader:Object;
		protected var _isComplete:Boolean=false;
		protected var _url:Object;
		protected var _rank:int=0;
		
		public function LoaderBase(loader:Object)
		{
			_loader=loader;
		}
		public function get isLoading():Boolean{
			return _isLoading;
		}
		public function get loader():Object{
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
		protected function onComplete(e:Event):void{
			_isLoading=false;
			_isComplete=true;
			dispatchEvent(e);
		}
	}
}
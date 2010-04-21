package view.player
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import view.ToolBitmapData;
	
	public class CacheMovieClip extends EventDispatcher
	{
		private var path:String;
		private var loader:Loader;
		protected static var movieCache:Dictionary=new Dictionary(true);
		private var cache:Array=[];
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		private var index:int=0;
		public function CacheMovieClip(path:String,x:Number,y:Number)
		{
			super(this);
			this.path=path;
			this.x=x;
			this.y=y;
			init();
		}
		private function init():void
		{
			loader=new Loader();
			loader.load(new URLRequest(this.path));
			movieCache[this.path]=cache;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function onComplete(e:Event):void
			{
				var content:MovieClip=MovieClip(loader.content);
				content.stop();
				for(var i:int=0;i<content.totalFrames;i++)
				{
					cache[i]=ToolBitmapData.getInstance().drawDisplayObject(content)
				}
				width=loader.width+1;
				height=loader.height+1;
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
				dispatchEvent(e);
				loader.unload();
				loader=null;
				content=null;
			},false,0,true);
		}
		public function getNextFrame():BitmapData
		{
			if(index+1==getValue().length)
			{
				index=0;
			}else
			{
				index++;
			}
			return getValue[index];
		}
		public function getValue():Array
		{
			return movieCache[this.path];
		}
		public function dispose():void
		{
			for each(var bitmap:BitmapData in cache)
			{
				bitmap.dispose();
				bitmap=null;
			}
			cache=null;
			movieCache[this.path]=null;
			this.path=null;
		}
	}
}
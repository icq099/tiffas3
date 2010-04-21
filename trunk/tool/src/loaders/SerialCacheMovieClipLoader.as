package loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import loaders.event.SerialLoaderEvent;
	import loaders.item.SerialCacheMovieClipItem;
	
	import view.player.CacheMovieClip;

	public class SerialCacheMovieClipLoader extends EventDispatcher
	{
		private var task:Array=new Array();
		private var loader:CacheMovieClip;
		private var index:int=0;
		private var tempContainer:Dictionary=new Dictionary();//加载完毕的数据都存到这里
		public function SerialCacheMovieClipLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function addItem(id:String,url:String,x:Number,y:Number):void
		{
			var item:SerialCacheMovieClipItem=new SerialCacheMovieClipItem();
			item.id=id;
			item.url=url;
			item.x=x;
			item.y=y;
			task.push(item);
		}
		public function start():void
		{
			initNewLoader();
		}
		public function getValue(id:String):CacheMovieClip
		{
			var temp:Array=tempContainer[id];
			if(!temp)
			{
				trace("指定id的数据"+id+"尚未加载完毕或不存在");
				return null;
			}
			return tempContainer[id];
		}
		private function initNewLoader():void
		{
			if(index==task.length)
			{
				this.dispatchEvent(new SerialLoaderEvent(SerialLoaderEvent.ALLCOMPLETE));
			}else
			{
				loader=new CacheMovieClip(task[index].url,task[index].x,task[index].y);
				loader.addEventListener(Event.COMPLETE,on_complete);
			}
		}
		private function on_complete(e:Event):void
		{
			this.dispatchEvent(new SerialLoaderEvent(SerialLoaderEvent.ITEMCOMPLETE,task[index].id));
			tempContainer[task[index].id]=loader;
			index++;
			loader=null;
			initNewLoader();
		}
		public function clear():void
		{
			task=new Array();
			tempContainer=new Dictionary(true);
		}
		public function dispose():void
		{
			task=null;
			tempContainer=null;
			if(loader!=null)
			{
				loader.dispose();
				loader=null;
			}
		}
	}
}
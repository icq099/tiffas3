package loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	
	import loaders.event.SerialXmlLoaderEvent;
	import loaders.item.SerialXmlLoaderItem;
	[Event(name="init", type="loaders.event.SerialXmlLoaderEvent")]
	[Event(name="itemcomplete", type="loaders.event.SerialXmlLoaderEvent")]
	[Event(name="allcomplete", type="loaders.event.SerialXmlLoaderEvent")]
	public class SerialXmlLoader extends EventDispatcher
	{
		private var isComplete:Boolean=false;
		private var task:Array=new Array();
		private var index:int=0;
		private var loader:XmlLoader;
		private var tempContainer:Dictionary=new Dictionary(true);//加载完毕的数据都存到这里
		public function SerialXmlLoader()
		{
			super(this);
		}
		public function addItem(id:String,url:String):void
		{
			var item:SerialXmlLoaderItem=new SerialXmlLoaderItem();
			item.id=id;
			item.url=url;
			task.push(item);
		}
		public function start():void
		{
			this.dispatchEvent(new SerialXmlLoaderEvent(SerialXmlLoaderEvent.INIT));
			initNewLoader();
		}
		private function initNewLoader():void
		{
			if(index==task.length)
			{
				this.dispatchEvent(new SerialXmlLoaderEvent(SerialXmlLoaderEvent.ALLCOMPLETE));
			}else
			{
				loader=new XmlLoader(task[index].url);
				loader.addEventListener(Event.COMPLETE,on_complete,false,0,true);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onError,false,0,true);
			}
		}
		private function on_complete(e:Event):void
		{
			this.dispatchEvent(new SerialXmlLoaderEvent(SerialXmlLoaderEvent.ITEMCOMPLETE,task[index].id));
			tempContainer[task[index].id]=loader.getXmlDataCopy();
			index++;
			loader.dispose();
			loader=null;
			initNewLoader();
		}
		private function onError(e:IOErrorEvent):void
		{
			trace("SerialXmlLoader::("+task[index].id+")数据加载失败!");
			index++;
			loader.dispose();
			loader=null;
			initNewLoader();
		}
		public function getValue(id:String):XML{
			var temp:XML=tempContainer[id];
			if(!temp)
			{
				trace("指定id的数据"+id+"尚未加载完毕或不存在");
				return null;
			}
			return tempContainer[id];
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
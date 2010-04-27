package util.loaders
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import memory.MemoryRecovery;
	
	import mx.controls.SWFLoader;
	
	public class SerialSwfLoader extends Sprite
	{
		private var task:Array=new Array();
		private var index:int=0;
		private var tempContainer:Dictionary=new Dictionary(true);//加载完毕的数据都存到这里
		private var loader:SWFLoader;
		public function SerialSwfLoader()
		{
			super();
		}
		public function add(id:String,url:String):void
		{
			var item:SerialSwfLoaderItem=new SerialSwfLoaderItem();
			item.id=id;
			item.url=url;
			task.push(item);
		}
		public function start():void
		{
			initLoader();
			this.addEventListener(Event.ENTER_FRAME,enter_frame);
		}
		private function enter_frame(e:Event):void
		{
			if(loader!=null)
			{
				var temp:Number=loader.bytesLoaded/loader.bytesTotal;
				if(index!=task.length)
				{
					if(temp<=1)
					{
						var event:ProgressEvent=new ProgressEvent(ProgressEvent.PROGRESS);
						event.bytesLoaded=(index/task.length+(loader.bytesLoaded/loader.bytesTotal)/task.length)*10000;
						event.bytesTotal=10000;
						this.dispatchEvent(event);
					}
				}else
				{
					MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,enter_frame);
				}
			}else
			{
				MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,enter_frame);
			}
		}
		private function initLoader():void
		{
			if(index==task.length)
			{
				this.dispatchEvent(new SerialSwfLoaderEvent(SerialSwfLoaderEvent.ALL_COMPLETE));
			}else
			{
				loader=new SWFLoader();
				loader.load(SerialSwfLoaderItem(task[index]).url);
				loader.addEventListener(Event.COMPLETE,on_complete,false,0,true);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onError,false,0,true);
			}
		}
		private function on_complete(e:Event):void
		{
			this.dispatchEvent(new SerialSwfLoaderEvent(SerialSwfLoaderEvent.ITEM_COMPLETE,task[index].id));
			tempContainer[task[index].id]=loader;
			index++;
			initLoader();
		}
		private function onError(e:IOErrorEvent):void
		{
			trace("SerialXmlLoader::("+task[index].id+")数据加载失败!");
			index++;
			loader.unloadAndStop();
			loader=null;
			initLoader();
		}
		public function getValue(id:String):SWFLoader{
			var temp:SWFLoader=tempContainer[id];
			if(!temp)
			{
				trace("指定id的数据"+id+"尚未加载完毕或不存在");
				return null;
			}
			return tempContainer[id];
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,enter_frame);
			task=null;
			tempContainer=null;
			loader=null;
		}
	}
}
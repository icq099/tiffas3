package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import yzhkof.loader.CompatibleURLLoader;
	import yzhkof.util.EventProxy;

	public class Mxml extends EventDispatcher
	{
		private static var _instance:Mxml;
		
		private var loader:CompatibleURLLoader=new CompatibleURLLoader();
		private var xml:XML;
		private var photoDataSet:Vector.<PhotoData>=new Vector.<PhotoData>;
		
		public var pageSize:uint=12;
		
		public function Mxml()
		{
			if(_instance)
				throw new Error("Singleton");	
			_instance=this;
			init();
		}
		public static function get Instance():Mxml
		{
			return _instance?_instance:new Mxml(); 
		}
		public function get pageCount():uint
		{
			return Math.ceil(photoDataSet.length/pageSize);
		}
		public function getPhotoData(page:uint):Vector.<PhotoData>
		{
			var re_arr:Vector.<PhotoData>=new Vector.<PhotoData>;
			var offset:uint=pageSize*page;
			for(var i:int=0;i<pageSize;i++)
			{
				re_arr.push(photoDataSet[offset+i]);
				if(offset+i>=photoDataSet.length-1)
				{
					break;
				}
			}
			return re_arr;
		}
		public function getNextPhotoData(data:PhotoData):PhotoData
		{
			var index:int = photoDataSet.indexOf(data);
			if(index >= photoDataSet.length -1)
				return null;
			return photoDataSet[index+1]
		}
		public function getPrePhotoData(data:PhotoData):PhotoData
		{
			var index:int = photoDataSet.indexOf(data);
			if(index <= 0)
				return null;
			return photoDataSet[index-1]
		}
		private function init():void
		{
			loader.loadURL("album1/config.xml");
//			loader.loadURL("config.xml");
			EventProxy.proxy(loader,this,[Event.COMPLETE]);
			this.addEventListener(Event.COMPLETE,__xmlLoadComplete);
		}
		private function __xmlLoadComplete(e:Event):void
		{
			xml=XML(loader.data);
			var length:uint=xml.photo.length();
			var i:int;
			for(i=0;i<length;i++)
			{
				var photo_xml:XML=xml.photo[i];
				photoDataSet.push(new PhotoData(photo_xml.@smallurl?photo_xml.@smallurl:photo_xml.@url,photo_xml.@url,photo_xml));
			}
		}
	}
}
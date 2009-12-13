package model
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.XMLListCollection;
	import mx.events.CollectionEvent;
	
	import yzhkof.util.XmlUtil;
	
	public class MXml extends EventDispatcher
	{
		[Bindable]
		public var xml_scene:XML;
		[Bindable]
		public var xml_menu:XML=new XML("loading...");
		[Bindable]
		public var xml_hotpoint:XML=new XML("loading...");
		[Bindable]
		public var isChange:Boolean=false;
		private var _isComplete:Boolean=false;
		private var loader:BulkLoader=BulkLoader.createUniqueNamedLoader();
		private var random_num:Number;
		private var xml_menu_watcher:XMLListCollection=new XMLListCollection();
		private var xml_hotpoint_watcher:XMLListCollection=new XMLListCollection();
		private static var _instance:MXml;
		
		public function MXml()
		{
			if(_instance!=null)
				throw new Error("error");
			_instance=this;
			xml_hotpoint_watcher.addEventListener(CollectionEvent.COLLECTION_CHANGE,onXmlChange);
			xml_menu_watcher.addEventListener(CollectionEvent.COLLECTION_CHANGE,onXmlChange);
		}
		public static function getInstance():MXml{
			if(_instance!=null)
				return _instance;
			return new MXml();
		}
		public function loadXml():void{
			random_num=Math.random();
			loader.add("xml/basic.xml?num="+random_num);
			loader.add("xml/menu.xml?num="+random_num);
			loader.add("xml/hotpoints.xml?num="+random_num);
			loader.start();
			loader.addEventListener(BulkProgressEvent.COMPLETE,onComplete);
		}
		[Bindable("isCompleteChanged")]
		public function get isComplete():Boolean{
			return _isComplete;
		}
		public function getHotPointXml(id:String):XMLList{
			return xml_hotpoint.HotPoint.(@id==id) as XMLList;
		}
		public function getHotPointXmlByIndex(index:int):XML{
			return xml_hotpoint.HotPoint[index];
		}
		public function addMenuXml(scene_index:int,hotpoint_id:String):void{
			xml_menu.Scene[scene_index].appendChild(new XML("<sample>"+hotpoint_id+"</sample>"));
		}
		public function deleteMenuXml(scene_index:int,sample_index:int):void{
			delete xml_menu.Scene[scene_index].sample[sample_index];
		}
		public function deleteHotPointXmlByIndex(index:int):void{
			var xml_list:XMLList=xml_menu.Scene..sample;
			var delete_list:XMLList=new XMLList();
			var length:int;
			for(var i:int=0;i<xml_list.length();i++){
			 	if(xml_list[i]==xml_hotpoint.HotPoint[index].@id){
					delete_list+=xml_list[i];
			 	}
			}
			XmlUtil.deleteXmlList(delete_list);
			delete xml_hotpoint.HotPoint[index];
		}
		private function onComplete(e:Event):void{
			xml_scene=loader.getXML("xml/basic.xml?num="+random_num);
			xml_menu=loader.getXML("xml/menu.xml?num="+random_num);
			xml_hotpoint=loader.getXML("xml/hotpoints.xml?num="+random_num);
			xml_menu_watcher.source=new XMLList()+xml_menu;
			xml_hotpoint_watcher.source=new XMLList()+xml_hotpoint;
			isChange=false;
			_isComplete=true;
			dispatchEvent(new Event("isCompleteChanged"));
		}
		private function onXmlChange(e:Event):void{
			isChange=true;
		}
	}
}
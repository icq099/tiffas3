package model
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class MXml extends EventDispatcher
	{
		[Bindable]
		public var xml_scene:XML;
		[Bindable]
		public var xml_menu:XML;
		[Bindable]
		public var xml_hotpoint:XML;
		private var _isComplete:Boolean=false;
		private var loader:BulkLoader=BulkLoader.createUniqueNamedLoader();
		private static var _instance:MXml;
		
		public function MXml()
		{
			if(_instance!=null)
				throw new Error("error");
			_instance=this;
		}
		public static function getInstance():MXml{
			if(_instance!=null)
				return _instance;
			return new MXml();
		}
		public function loadXml():void{
			loader.add("xml/basic.xml");
			loader.add("xml/menu.xml");
			loader.add("xml/hotpoints.xml");
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
			xml_menu.Scene[scene_index].appendChild(hotpoint_id);
		}
		public function deleteMenuXml(scene_index:int,sample_index:int):void{
			delete xml_menu.Scene[scene_index].sample[sample_index];
		}
		public function deleteHotPointXmlByIndex(index:int):void{
			delete xml_hotpoint.HotPoint[index];
		}
		private function onComplete(e:Event):void{
			xml_scene=loader.getXML("xml/basic.xml");
			xml_menu=loader.getXML("xml/menu.xml");
			xml_hotpoint=loader.getXML("xml/hotpoints.xml");
			_isComplete=true;
			dispatchEvent(new Event("isCompleteChanged"));
		}
	}
}
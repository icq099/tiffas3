package proxys
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import facades.FacadePv;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import mx.managers.BrowserManager;
	import mx.utils.URLUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PXml extends Proxy implements IProxy
	{
		public static const NAME:String="PXml"
		
		protected var data_hotpoints:XML;
		protected var data_icon:XML;
		protected var data_menu:XML;
		protected var data_plugin:XML;
		
		private var xml_loader:BulkLoader;
		
		private var icon_bitmapdata:Array=new Array();
		private var plugin:Array=new Array();
		
		public function PXml()
		{
			super(NAME);
		}
		public function loadXml():void{
			
			xml_loader=new BulkLoader("xml");
			xml_loader.add("xml/basic.xml");
			//xml_loader.add("xml/hotpoints.xml");
			xml_loader.add("xml/icon.xml");
			//xml_loader.add("xml/menu.xml");
			xml_loader.add("xml/plugin.xml");
			xml_loader.start();
			xml_loader.addEventListener(BulkProgressEvent.COMPLETE,loadCompleteHandler);
		
		}
		public function getXml():XML{
			
			return XML(data);
		
		}
		public function get xml():XML{
			
			return XML(data);
		
		}
		public function getSceneXml():XMLList{
			
			return XML(data).Travel.Scene;
		
		}
		public function getHotPointsXml():XMLList{
			
			return XMLList(data_hotpoints.HotPoint);
			//return xml..HotPoint;
		
		}
		public function getSceneHotPointsPositionXml(position:int):XMLList{
			
			return XML(data).Travel.Scene[position].HotPoint;
			/* for each(var i:XML in hot_points_id){
				
				re_array.push(i.@id);
			
			}
			return re_array; */
		
		}
		public function getMapTextBySceneId(id:int):String{
									
			return String(XML(data).Travel.Scene[id].@guideText);
		
		}
		public function getScenePluginPositionXml(position:int):XMLList{
			
			return XML(data).Travel.Scene[position].Plugin;
			/* for each(var i:XML in hot_points_id){
				
				re_array.push(i.@id);
			
			}
			return re_array; */
		
		}
		public function getHotPointXmlById(id:String):XML{
			
			return XML(String(data_hotpoints.HotPoint.(@id==id)));
		
		}
		public function getGuideSwf(id:String):String{
			
			if(getSceneXml()[id].@guideSwf.length()>0){
				
				return getSceneXml()[id].@guideSwf;
			
			}else{
				
				return null;
			
			}
		
		}
		public function getStartPosition():int{
			
			return int(data.Travel.@start_scene) as int;
		
		}
		public function getIconBitmapdataById(id:int):BitmapData{
			
			return icon_bitmapdata[id];
		
		}
		public function getPluginXmlById(id:String):XML{
			return XML(String(data_plugin.plugin.(@id==id)));
		}
		public function getPluginXml():XML{
			return data_plugin;
		}
		public function getMenuXml():XML{
			
			return XML(data_menu);
		
		}
		public function getSceneXmlById():XML{
			return XML(String(data.Travel.Scene.(@id==id)));
		}
		public function getUrlObject():Object{
			
			return URLUtil.stringToObject(BrowserManager.getInstance().fragment,"&");
		
		}
		private function loadCompleteHandler(e:Event):void{
			
			data=xml_loader.getXML("xml/basic.xml");
			//data_hotpoints=xml_loader.getXML("xml/hotpoints.xml");
			data_icon=xml_loader.getXML("xml/icon.xml");
			//data_menu=xml_loader.getXML("xml/menu.xml");
			data_plugin=xml_loader.getXML("xml/plugin.xml");
			xml_loader.clear();
			xml_loader=null;
			
			loadExternal();
			
		}
		private function loadExternal():void{
			
			var external_loader:BulkLoader=new BulkLoader("icon");
			//载入图标
			for each(var i:XML in data_icon.icon){
				external_loader.add(String(i.@url))
			}
			//载入外部插件
			for each(i in data_plugin.plugin){
				if(i.@preLoad==1){
					external_loader.add(String(i.@url));
				}
			}
			
			external_loader.addEventListener(BulkProgressEvent.COMPLETE,loadExternalComplete);
			external_loader.start();
		
		}
		private function loadExternalComplete(e:Event):void{
			
			BrowserManager.getInstance().init();
			for each(var i:XML in data_icon.icon){
				
				icon_bitmapdata.push(BulkLoader(e.currentTarget).getBitmap(String(i.@url)).bitmapData);
				
			}
			/* var obj:Object;
			var b_loader:BulkLoader;
			for each(i in data_plugin.plugin){
				
				b_loader=BulkLoader(e.currentTarget);
				obj=b_loader.hasItem(String(i.@url))?b_loader.getContent(String(i.@url)):null
				plugin.push(obj);
				
			} */
			BulkLoader(e.currentTarget).clear();
			
			var pre_array:Array=new Array();
			
			var xml_travel:XMLList=getXml().Travel;
			
			if(!getUrlObject().hasOwnProperty("scene")){
			
				if(xml_travel.@openingMovie.length()>0){
					
					pre_array.push(xml_travel.@openingMovie);
					PTravel(facade.retrieveProxy(PTravel.NAME)).currentPosition=int(xml_travel.@start_scene);
					
				}else{
					
					pre_array.push(getSceneXml()[int(xml_travel.@start_scene)].@picture);
					
				}
				
			}else{
				
				pre_array.push(getSceneXml()[int(getUrlObject().scene)].@picture);		
			
			}
			
			facade.sendNotification(FacadePv.PRE_INIT_LOAD,pre_array);
		
		}
		
	}
}
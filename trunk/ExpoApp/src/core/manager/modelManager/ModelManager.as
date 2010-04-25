package core.manager.modelManager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import loaders.SerialXmlLoader;
	import loaders.event.SerialXmlLoaderEvent;
	
	import memory.MyGC;
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class ModelManager extends EventDispatcher
	{
		private static var _instance:ModelManager;
		private const totalXml:int=7;               //总的XML数目，要是要添加或减少XML，记得修改这个数值
		private var xmlLoaded:int=0;                //已经加载的XML数目
		private var _animateXml:XML;                //桂娃的XML
		private var _basicXml:XML;                  //业务逻辑的XML
		private var _gehaiqingyunXml:XML;           //歌海情韵的数据
		private var _itemXml:XML;                   //标准窗的数据
		private var _pluginXml:XML;                 //插件的数据
		private var _popumenuXml:XML;               //1，2级菜单的数据
		private var _pv3dXml:XML;                   //PV3D的数据
		public function ModelManager()
		{
			if(_instance==null)
			{
				super();
				_instance=this;
			}else
			{
				throw new Error("ModuleManager不能被实例化");
			}
			init();
		}
		private var loader:SerialXmlLoader;//用来加载XML
		private function init():void
		{
			loader=new SerialXmlLoader();
			loader.addItem("animate","xml/animate.xml");
			loader.addItem("basic","xml/basic.xml");
			loader.addItem("gehaiqingyun","xml/gehaiqingyun.xml");
			loader.addItem("item","xml/item.xml");
			loader.addItem("plugin","xml/plugin.xml");
			loader.addItem("popumenu","xml/popumenu.xml");
			loader.addItem("pv3d","xml/pv3d.xml");
			MyGC.gc();
			loader.addEventListener(SerialXmlLoaderEvent.ALLCOMPLETE,function on_all_complete(e:SerialXmlLoaderEvent):void{
				_animateXml=loader.getValue("animate");
				_basicXml=loader.getValue("basic");
				_gehaiqingyunXml=loader.getValue("gehaiqingyun");
				_itemXml=loader.getValue("item");
				_pluginXml=loader.getValue("plugin");
				_popumenuXml=loader.getValue("popumenu");
				_pv3dXml=loader.getValue("pv3d");
				loader.removeEventListener(SerialXmlLoaderEvent.ALLCOMPLETE,on_all_complete);
				loader.dispose();
				loader=null
				ModelManager.getInstance().dispatchEvent(new Event(Event.COMPLETE));//抛出加载完毕的事件
			});
			loader.addEventListener(SerialXmlLoaderEvent.ITEMCOMPLETE,function on_item_complete(e:SerialXmlLoaderEvent):void{
				var event:ProgressEvent=new ProgressEvent(ProgressEvent.PROGRESS);
				event.bytesTotal=totalXml;
				event.bytesLoaded=++xmlLoaded;
				dispatchEvent(event);//抛出XML文件加载进度
			});
			loader.start();
		}
		public static function getInstance():ModelManager
		{
			if(_instance==null)
			{
				_instance=new ModelManager();
			}
			return _instance;
		}
		////////////////////////////////////////////下面是供外界读取数据
		public function get xmlAnimate():XML//桂娃ID和路径的数据
		{
			if(_animateXml==null) return null;
			return _animateXml.copy();
		}
		public function get xmlBasic():XML//场景配置的数据
		{
			if(_basicXml==null) return null;
			return _basicXml.copy();
		}
		public function get xmlGehaiqingyun():XML//歌海情韵的数据
		{
			if(_gehaiqingyunXml==null) return null;
			return _gehaiqingyunXml.copy();
		}
		public function get xmlItem():XML//标准窗的数据
		{
			if(_itemXml==null) return null;
			return _itemXml.copy();
		}
		public function get xmlPlugin():XML//插件的数据
		{
			if(_pluginXml==null) return null;
			return _pluginXml.copy();
		}	
		public function get xmlPopumenu():XML//1,2级菜单的数据
		{
			if(_popumenuXml==null) return null;
			return _popumenuXml.copy();
		}	
		public function get xmlPv3d():XML//pv3d的数据
		{
			if(_pv3dXml==null) return null;
			return _pv3dXml.copy();
		}	
	}
}
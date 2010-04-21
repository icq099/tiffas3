package core.manager.pluginManager
{
	import core.manager.modelManager.ModelManager;
	import core.manager.pluginManager.event.PluginEvent;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	import mx.containers.Canvas;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import structure.HashMap;
	[Event(name="ready", type="manager.pluginManager.event.PluginEvent")]
	[Event(name="complete", type="manager.pluginManager.event.PluginEvent")]
	[Event(name="progress", type="manager.pluginManager.event.PluginEvent")]
	[Event(name="removed", type="manager.pluginManager.event.PluginEvent")]
	public class PluginManager extends EventDispatcher
	{
		private static var _instance:PluginManager;
		private var pluginList:HashMap=new HashMap(true);//存储插件的引用
		private var floorList:Array=new Array();         //存储层次
		private var pluginDataIndex:HashMap=new HashMap(true);
		private const floorNumber:int=5;
		public const maxFloor:int=floorNumber-1;
		public const minFloor:int=0;
		private var parent:*;
		private var pluginXml:XML;                      //插件的数据库
		public function PluginManager()
		{
			if(_instance==null)
			{
				super();
				_instance=this;
			}else
			{
				throw new Error("ModuleManager不能被实例化");
			}
		}
		//初始化插件管理者，已经初始化的话就不能再初始化了
		public function init(parent:*):void
		{
			ScriptManager.getInstance().addApi(ScriptName.SHOWPLUGINBYID,showPluginById);//添加显示插件的脚本
			ScriptManager.getInstance().addApi(ScriptName.SHOWSINGLEPLUGINBYID,showSinglePluginById);
			if(this.parent==null && parent!=null)
			{
				this.parent=parent;
				pluginXml=ModelManager.getInstance().xmlPlugin;//存储plugin数据库的引用
				initFloors();
				initPlugins();
			}else
			{
				trace("ModuleManager已经初始化或者所给的参数为空");
			}
		}
		public function showSinglePluginById(pluginName:String):Boolean
		{
			if(getPluginObject(pluginName)==null)
			{
				showPluginById(pluginName);
			}else
			{
				trace("指定的插件:"+pluginName+"已经存在，不再添加");
				return false;
			}
			return true;
		}
		//显示要显示的插件,并存储插件
		private function initPlugins():void
		{
			for(var i:int=0;i<pluginXml.plugin.length();i++)
			{
				var item:PluginItem=new PluginItem();
				item.id=pluginXml.plugin[i].@id;
				item.url=pluginXml.plugin[i].@url;
				item.floor=pluginXml.plugin[i].@floor?pluginXml.plugin[i].@floor:0;
				item.x=pluginXml.plugin[i].@x?pluginXml.plugin[i].@x:0;
				item.y=pluginXml.plugin[i].@y?pluginXml.plugin[i].@y:0;
				pluginDataIndex.put(item.id,item);
				if(pluginXml.plugin[i].@visible=="1")
				{
					showPlugin(item.id,item.url,item.floor,item.x,item.y);
				}
			}
		}
		//初始化容器，容器共floorNumber层
		private function initFloors():void
		{
			for(var i:int=0;i<floorNumber;i++)
			{
				var floor:Canvas=new Canvas();
				floorList.push(floor);
				this.parent.addChild(floor);
			}
		}
		//更换插件的层次
		public function changeLayerById(id:String,floor:int):void
		{
			var dis:DisplayObject=getPlugin(id);
			var currentFloor:int=getPluginFloor(id);
			if(dis!=null && currentFloor!=floor)
			{
				if(dis.parent)
				{
					dis.parent.removeChild(dis);
				}
				Canvas(floorList[floor]).addChild(dis);
			}else
			{
				trace("插件为空，或者插件已经在所指定的层次");
			}
		}
		public static function getInstance():PluginManager
		{
			if(_instance==null) _instance=new PluginManager();
			return _instance;
		}
		//根据名字显示插件
		public function showPluginById(id:String):Boolean
		{
			var item:PluginItem=PluginItem(pluginDataIndex.getValue(id));
			if(item==null)
			{
				trace("插件:"+id+"不存在");
				return false;
			}
			showPlugin(item.id,item.url,item.floor,item.x,item.y);
			return true;
		}
		//根据详细参数显示插件
		public function showPlugin(id:String,url:String,floor:int,x:int,y:int):void
		{
			var loader:ModuleLoader=new ModuleLoader();
			loader.applicationDomain=ApplicationDomain.currentDomain;
			//处理ready事件
			loader.addEventListener(ModuleEvent.READY,function ready(e:ModuleEvent):void{
				loader.removeEventListener(ModuleEvent.READY,ready);
				if(!loader.child is IPlugin){
					throw new Error(url+"插件必需实现IPlugin接口!");
				}
				var object:Object={id:id,url:url,floor:floor,plugin:loader.child,loader:loader};
				pluginList.put(id,object);
				PluginManager.getInstance().dispatchEvent(new PluginEvent(PluginEvent.READY,id,floor,loader.child));
			});
			//处理PROGRESS事件
			loader.addEventListener(ModuleEvent.PROGRESS,function PROGRESS(e:ModuleEvent):void{
				var event:PluginEvent=new PluginEvent(PluginEvent.PROGRESS,id,floor,loader.child);
				event.byteLoaded=e.bytesLoaded;
				event.byteTotal=e.bytesTotal;
				PluginManager.getInstance().dispatchEvent(event);//抛出进度事件
				if(e.bytesLoaded==e.bytesTotal)
				{
					loader.removeEventListener(ModuleEvent.PROGRESS,PROGRESS);
					PluginManager.getInstance().dispatchEvent(new PluginEvent(PluginEvent.COMPLETE,id,floor,loader.child));//抛出下载完毕的事件
				}
			});
			loader.url=url;
			if(floor<0)
			{
				floorList[0].addChild(loader);
				trace("PluginManager::指定的层次小于0，将使用0号层存储插件");
			}
			else if(floor<floorList.length)
			{
				floorList[floor].addChild(loader);
				loader.x=x;loader.y=y;
			}else
			{
				floorList[floorList.length-1].addChild(loader);
				trace("PluginManager::指定的层次大于最高层次，将使用最高层存储插件!");
			}
		}
		//删除插件
		public function removePluginById(id:String):Boolean{
			try
			{
				var pluginObj:Object=getPluginObject(id);
				var moduleLoader:ModuleLoader=pluginObj.loader;
				pluginList.remove(id);
				IPlugin(moduleLoader.child).dispose();
				floorList[pluginObj.floor].removeChild(moduleLoader);
				moduleLoader.child=null;
				moduleLoader.unloadModule();
				moduleLoader=null;
				pluginObj.id=null;pluginObj.url=null;pluginObj.loader=null;pluginObj.plugin=null;
				pluginObj=null;
				PluginManager.getInstance().dispatchEvent(new PluginEvent(PluginEvent.REMOVED,id));
			}catch(e:Error)
			{
				trace("PluginManager删除插件:"+e);
				return false;
			}
			return true;
		}
		public function getPluginObject(id:String):Object{
			return pluginList.getValue(id);
		}
		public function getPlugin(id:String):*
		{
			return pluginList.getValue(id).loader;
		}
		public function getPluginUrl(id:String):String{
			return pluginList.getValue(id).url;
		}
		public function getPluginFloor(id:String):int{
			return pluginList.getValue(id).floor;
		}
	}
}
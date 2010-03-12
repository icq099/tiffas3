package core.pluginManager
{
	import core.pluginManager.model.PluginModel;
	import core.pluginManager.model.PluginModelItem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.Application;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import plugins.interfaces.IPluginGC;
	
	public class PluginManager extends EventDispatcher
	{
		private static var _instance:PluginManager;
		private var _pluginModel:PluginModel;
		private var imi:IModuleInfo;
		private var _pluginList:Array;
		public function PluginManager()
		{
			if(_instance==null)
			{
				super(this);
				_instance=this;
			}else
			{
				throw new Error("PluginManager cann't be new!");
			}
			init();
		}
		private function init():void
		{
			_pluginModel=new PluginModel();
			_pluginModel.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void
		{
			_pluginModel.removeEventListener(Event.COMPLETE,onComplete);
			showVisiblePlugins();
		}
		//根据场景节点更新插件
		public function updatePluginsById(id:int):void
		{
			var scenePluginList:Array=_pluginModel.sceneMap[id];
			
		}
		//显示所有默认是可见的插件
		private function showVisiblePlugins():void
		{
			if(_pluginModel!=null)
			{
				_pluginList=_pluginModel.pluginList;
				for each(var item:PluginModelItem in _pluginList)
				{
					if(item.visible)
					{
						showPluginById(item.id);
					}
				}
			}
		}
		//当前的数据
		private var currentModelItem:PluginModelItem;
		private var visiblePlugins:Array=new Array();
		private var currentIndex:int=-1;
		private var imis:Array=new Array();
		//显示插件
		public function showPluginById(id:String):void
		{
			if(_pluginModel!=null)
			{
				currentModelItem=PluginModelItem(_pluginModel.pluginMap[id]);
				visiblePlugins.push(currentModelItem);
				var imi:IModuleInfo=ModuleManager.getModule(currentModelItem.url);
				imis.push(imi);
				IModuleInfo(imis[imis.length-1]).addEventListener(ModuleEvent.READY,ready);
				IModuleInfo(imis[imis.length-1]).load();
			}
			else
			{
				trace("插件的数据未初始化");
			}
		}
		private function ready(e:ModuleEvent):void
		{
			var dis:IPluginGC=imis[++currentIndex].factory.create() as IPluginGC;
			DisplayObject(dis).x=visiblePlugins[currentIndex].x;
			DisplayObject(dis).y=visiblePlugins[currentIndex].y;
			Application.application.addChild(dis);
		}
		//根据ID更新所有的plugins
		//获取pluginManager的对象
		public static function getInstance():PluginManager
		{
			if(_instance!=null)
			{
				return _instance;
			}else
			{
				_instance=new PluginManager();
			}
			return _instance;
		}
	}
}
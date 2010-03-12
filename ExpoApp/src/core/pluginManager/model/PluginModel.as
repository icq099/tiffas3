package core.pluginManager.model
{
	import shares.models.XmlLoaderModel;
	
	public class PluginModel extends XmlLoaderModel
	{
		private var _map:Object=new Object();//插件列表,在BASIC.XML里面排头的那些PLUGIN
		private var _array:Array;//插件列表,在BASIC.XML里面排头的那些PLUGIN
		private var _sceneMap:Array;//场景里的插件列表
		public function PluginModel()
		{
			super("xml/basic.xml");
		}
		public function get sceneMap():Array
		{
			if(_sceneMap!=null) return _sceneMap;
			_sceneMap=new Array();
			var sceneLength:int=xmlData.Scenes.Scene.length();
			var pluginLength:int;
			var sceneNode:Array;
			for(var i:int=0;i<sceneLength;i++)
			{
				pluginLength=xmlData.Scenes.Scene[i].Plugin.length();
				sceneNode=new Array();
				for(var j:int=0;j<pluginLength;j++)
				{
					sceneNode.push(xmlData.Scenes.Scene[i].Plugin[j].id);
				}
				_sceneMap.push(sceneNode);
			}
			return _sceneMap;
		}
		//获取插件列表+初始化列表
		public function get pluginList():Array
		{
			if(_array!=null)
			{
				return _array;
			}
			else
			{
				_array=new Array();
				var length:int=xmlData.Plugins.Plugin.length();
				for(var i:int=0;i<length;i++)
				{
					var modelItem:PluginModelItem=new PluginModelItem();
					modelItem.id=xmlData.Plugins.Plugin[i].@id;//id
					modelItem.url=xmlData.Plugins.Plugin[i].@url;//路径
					//是否可见
					if(xmlData.Plugins.Plugin[i].@visible=="1")
					{
						modelItem.visible=true;
					}else
					{
						modelItem.visible=false;
					}
					if(xmlData.Plugins.Plugin[i].@x==null || xmlData.Plugins.Plugin[i].@x=="")
					{
						modelItem.x=0;
					}
					else
					{
						modelItem.x=int(xmlData.Plugins.Plugin[i].@x);
					}
					if(xmlData.Plugins.Plugin[i].@y==null || xmlData.Plugins.Plugin[i].@y=="")
					{
						modelItem.y=0;
					}
					else
					{
						modelItem.y=int(xmlData.Plugins.Plugin[i].@y);
					}
					_array.push(modelItem);//以数组的形式存储数据
					_map[xmlData.Plugins.Plugin[i].@id]=modelItem;//以变量的形式存储数据
				}
				return _array;
			}
			return null;
		}
		//返回插件的列表
		public function get pluginMap():Object
		{
			return _map;
		}
	}
}
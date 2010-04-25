package core.manager.pluginManager.event
{
	import core.manager.sceneManager.SceneManager;
	
	import flash.events.Event;

	public class PluginEvent extends Event
	{
		public static var READY:String="PluginEvent.READY";       //插件准备完毕
		public static var COMPLETE:String="PluginEvent.COMPLETE"; //插件下载完毕
		public static var PROGRESS:String="PluginEvent.PROGRESS"; //插件正在下载
		public static var REMOVED:String="PluginEvent.REMOVED";   //删除插件
		public static var UPDATE:String="PluginEvent.UPDATE";     //插件更新
		public var id:String;
		public var _plugin:*;
		public var floor:int;
		public var byteLoaded:Number;
		public var byteTotal:Number;
		public function PluginEvent(type:String,id:String=null,floor:int=9999,plugin:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.id=id;
			this._plugin=plugin;
			this.floor=floor;
		}
		
	}
}
package mediators
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import yzhkof.PositionSeter;
	import yzhkof.Toolyzhkof;

	public class PluginMediator extends Mediator
	{
		public static const NAME:String="PluginMediator";
		//消息体为当前plugin的xml数据
		public static const SHOW_PLUGIN:String="PluginMediator.SHOW_PLUGIN";
		//消息体为当前plugin的xml数据
		public static const REMOVE_PLUGIN:String="PluginMediator.REMOVE_PLUGIN";
		
		protected var plugin_obj:Object=new Object;
		public function PluginMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public override function listNotificationInterests():Array{
			return[
			SHOW_PLUGIN,
			REMOVE_PLUGIN
			];
		}
		public override function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case PluginMediator.SHOW_PLUGIN:
					showPlugin(XML(notification.getBody()));
				break;
				case PluginMediator.REMOVE_PLUGIN:
					removePlugin(XML(notification.getBody()));
				break;
			}			
		}
		protected function showPlugin(xml:XML):void{
			var loader:Loader=new Loader();
			loader.load(new URLRequest(xml.@url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPluginLoadComplete);
			
			plugin_container.addChild(plugin_obj[xml.@url]=Toolyzhkof.mcToUI(loader));
			var position_obj:Object=new Object();
			position_obj["left"]=xml.@left;
			position_obj["top"]=xml.@top;
			position_obj["right"]=xml.@right;
			position_obj["bottom"]=xml.@bottom;
			position_obj["x"]=xml.@x;
			position_obj["y"]=xml.@y;
			new PositionSeter(loader,position_obj,false,true);
		}
		protected function removePlugin(xml:XML):void{
			plugin_container.removeChild(plugin_obj[xml.@url]);
			delete plugin_obj[xml.@url];
		}
		protected function onPluginLoadComplete(e:Event):void{
			
			
		}
		protected function get plugin_container():Canvas{
			return viewComponent as Canvas;
		}
		
	}
}
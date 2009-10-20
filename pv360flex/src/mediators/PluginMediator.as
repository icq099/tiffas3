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
		protected var position_setters:Object=new Object;
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
			
			var position_obj:Object=new Object();
			position_obj["left"]=xml.@left.length()>0?xml.@left:undefined;
			position_obj["top"]=xml.@top.length()>0?xml.@top:undefined;
			position_obj["right"]=xml.@right.length()>0?xml.@right:undefined;
			position_obj["bottom"]=xml.@bottom.length()>0?xml.@bottom:undefined;
			position_obj["x"]=xml.@x.length()>0?xml.@x:undefined;
			position_obj["y"]=xml.@y.length()>0?xml.@y:undefined;
			position_obj["horizontalCenter"]=xml.@horizontalCenter.length()>0?xml.@horizontalCenter:undefined;
			position_obj["verticalCenter"]=xml.@verticalCenter.length()>0?xml.@verticalCenter:undefined;
			
			plugin_container.addChild(plugin_obj[xml.@url]=Toolyzhkof.mcToUI(loader));
			position_setters[xml.@url]=new PositionSeter(loader,position_obj,false,true);
		}
		protected function removePlugin(xml:XML):void{
			plugin_container.removeChild(plugin_obj[xml.@url]);
			delete plugin_obj[xml.@url];
			delete position_setters[xml.@url]
		}
		protected function onPluginLoadComplete(e:Event):void{
			
			
		}
		protected function get plugin_container():Canvas{
			return viewComponent as Canvas;
		}
		
	}
}
package mediators
{
	import communication.Event.MainSystemEvent;
	import communication.MainSystem;
	import communication.main_system;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import yzhkof.PositionSeter;

	public class PluginMediator extends Mediator
	{
		
		use namespace main_system;
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
			removePlugin(xml);
			var loader:ModuleLoader=new ModuleLoader();
			loader.applicationDomain=ApplicationDomain.currentDomain;
			loader.addEventListener(ModuleEvent.READY,function(e:ModuleEvent):void{
				var event:MainSystemEvent=new MainSystemEvent(MainSystemEvent.ON_PLUGIN_READY);
				event.paramOnPluginReady(xml.@id,loader.child);
				MainSystem.getInstance().addPlugin(xml.@id,loader.child);
				MainSystem.getInstance().dispatchEvent(event);				
			});
			loader.url=xml.@url;
			var position_obj:Object=new Object();
			position_obj["left"]=xml.@left.length()>0?xml.@left:undefined;
			position_obj["top"]=xml.@top.length()>0?xml.@top:undefined;
			position_obj["right"]=xml.@right.length()>0?xml.@right:undefined;
			position_obj["bottom"]=xml.@bottom.length()>0?xml.@bottom:undefined;
			position_obj["x"]=xml.@x.length()>0?xml.@x:undefined;
			position_obj["y"]=xml.@y.length()>0?xml.@y:undefined;
			position_obj["horizontalCenter"]=xml.@horizontalCenter.length()>0?xml.@horizontalCenter:undefined;
			position_obj["verticalCenter"]=xml.@verticalCenter.length()>0?xml.@verticalCenter:undefined;
			
			plugin_container.addChild(plugin_obj[xml.@id]=loader);
			position_setters[xml.@id]=new PositionSeter(loader,position_obj,false,true);
			
		}
		protected function removePlugin(xml:XML):void{
			try{
				plugin_container.removeChild(plugin_obj[xml.@id]);
				delete plugin_obj[xml.@id];
				delete position_setters[xml.@id];
				MainSystem.getInstance().removePlugin(xml.@id);
			}catch(e:Error){
			}
		}
		protected function get plugin_container():Canvas{
			return viewComponent as Canvas;
		}
		
	}
}
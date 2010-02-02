package mediators
{
	import communication.Event.MainSystemEvent;
	import communication.IPlugin;
	import communication.MainSystem;
	import communication.main_system;
	
	import flash.system.ApplicationDomain;
	
	import mx.containers.Canvas;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import yzhkof.PositionSeter;
	import yzhkof.util.HashMap;

	public class PluginMediator extends Mediator
	{
		
		use namespace main_system;
		public static const NAME:String="PluginMediator";
		//消息体为当前plugin的xml数据
		public static const SHOW_PLUGIN:String="PluginMediator.SHOW_PLUGIN";
		//消息体为当前plugin的xml数据
		public static const REMOVE_PLUGIN:String="PluginMediator.REMOVE_PLUGIN";
		
		protected var plugin_map:HashMap=new HashMap;
		
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
					var xml:XML=XML(notification.getBody());
					if(!plugin_map.containsKey(xml.@id)){
						showPlugin(xml);
					}
				break;
				case PluginMediator.REMOVE_PLUGIN:
					removePlugin(XML(notification.getBody()));
				break;
			}			
		}
		protected function showPlugin(xml:XML):void{
			var loader:ModuleLoader=new ModuleLoader();
			loader.applicationDomain=ApplicationDomain.currentDomain;
			loader.addEventListener(ModuleEvent.READY,function(e:ModuleEvent):void{
				if(!loader.child is IPlugin){
					throw new Error(xml.@id+"插件必需实现IPlugin接口!");
				}
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
		
			var plugin_obj:Object=new Object();
			plugin_obj.index=xml.@index;
			plugin_obj.loader=loader;
			
			var index:Array=plugin_map.valueSet;
			index.push(plugin_obj);
			index.sortOn("index",Array.NUMERIC);
			plugin_container.addChildAt(loader,index.indexOf(plugin_obj));
			
			plugin_obj.position=new PositionSeter(loader,position_obj,false,true);
			plugin_map.put(xml.@id,plugin_obj);
			
		}
		protected function removePlugin(xml:XML):void{
			try{
				IPlugin(plugin_map.getValue(xml.@id).child).dispose();
				plugin_container.removeChild(plugin_map.getValue(xml.@id).loader);
			}catch(e:Error){
				trace(e);
			}
			plugin_map.remove(xml.@id);
			MainSystem.getInstance().removePlugin(xml.@id);
		}
		protected function get plugin_container():Canvas{
			return viewComponent as Canvas;
		}
		
	}
}
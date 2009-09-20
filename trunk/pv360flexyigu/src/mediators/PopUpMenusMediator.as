package mediators
{
	import facades.FacadePv;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxys.PTravel;
	import proxys.PXml;
	
	import view.Event.ExhitbitSoundEvent;
	import view.PopMenusFlex;
	
	import yzhkof.Toolyzhkof;

	public class PopUpMenusMediator extends Mediator
	{
		public static const NAME:String="PopUpMenus";
		public static const ADD_PLUGIN:String="ADD_PLUGIN";
		
		private var swf_array:Array=new Array();
		private var xml:XML;
		private var p_xml:PXml;
		private var p_travel:PTravel;
		
		public function PopUpMenusMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array{
			
			return [
				
				FacadePv.POPUP_MENU_DIRECT,
				FacadePv.HOT_POINT_CLICK,
				FacadePv.LOAD_XML_COMPLETE,
				PopUpMenusMediator.ADD_PLUGIN
			
			]
			
		}
		override public function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case FacadePv.LOAD_XML_COMPLETE:
					
					xml=new XML(notification.getBody());
					p_xml=facade.retrieveProxy(PXml.NAME) as PXml;
					p_travel=facade.retrieveProxy(PTravel.NAME) as PTravel;
				
				break;
				case FacadePv.HOT_POINT_CLICK:
					
					popUpMenu(getClickXml(notification.getBody() as int));
				
				break;
				case FacadePv.POPUP_MENU_DIRECT:
					
					popUpMenu(p_xml.getHotPointXmlById(String(notification.getBody())));
					
				break;
				case PopUpMenusMediator.ADD_PLUGIN:
				
					addPlugin(String(notification.getBody()));
				
				break;
			
			}
		}
		private function popUpMenu(i_xml:XML):void{
			
			pop_menus.stage.quality=StageQuality.HIGH;
			
			/* var position:int=PTravel(facade.retrieveProxy(PTravel.NAME)).currentPosition;
			var xml_hot_point:XMLList=xml.Travel.Scene[position].HotPoint; */
			
			//菜单计数器加1
			p_travel.menu_count++;
			
			var menu:PopMenusFlex=new PopMenusFlex();
			
			menu.addEventListener(ExhitbitSoundEvent.PLAY,soundPlayHandler);
			menu.addEventListener(ExhitbitSoundEvent.PAUSE_OR_STOP,soundPauseHandler);
			menu.addEventListener(CloseEvent.CLOSE,windowCloseHandler);
			
			pop_menus.addChild(menu);
			menu.validateNow();
			menu.constructByXml(i_xml);
			//menu.width=i_xml.@swfWidth;
			//menu.height=i_xml.@swfHeight;
			menu.x=(pop_menus.stage.stageWidth-menu.width)/2;
			menu.y=(pop_menus.stage.stageHeight-menu.height)/2;
			
			
			
		
		}
		private function soundPlayHandler(e:Event):void{
			
			facade.sendNotification(SoundPlayerMediator.PAUSE_SOUND);
			facade.sendNotification(AnimatePlayerMediator.HIDE_ANIMATE);
		
		}
		private function soundPauseHandler(e:Event):void{
			
			facade.sendNotification(SoundPlayerMediator.RESUME_SOUND);
		
		}
		private function getClickXml(point_num:int):XML{
			
			var position:int=PTravel(facade.retrieveProxy(PTravel.NAME)).currentPosition;
			var id_hot_point:XMLList=xml.Travel.Scene[position].HotPoint;
			var xml_hot_point:XML=PXml(facade.retrieveProxy(PXml.NAME)).getHotPointXmlById(id_hot_point.@id[point_num]);
			return xml_hot_point;
		
		}
		private function windowCloseHandler(e:Event):void{
			
			p_travel.menu_count-=1;
			
		
		}
		private function addPlugin(url:String):void{
			
			pop_menus.stage.quality=StageQuality.HIGH;
			p_travel.menu_count++;
			var loader:Loader=new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPluginComplete);
			
		
		}
		private function onPluginComplete(e:Event):void{
			
			var loader:Loader=LoaderInfo(e.currentTarget).loader as Loader;
			var ui_com:UIComponent=Toolyzhkof.mcToUI(loader);
			pop_menus.addChild(ui_com);
			loader.x=(pop_menus.stage.stageWidth-loader.width)/2;
			loader.y=(pop_menus.stage.stageHeight-loader.height)/2;
			
			loader.addEventListener("plugin_close",function(e:Event):void{
				
				pop_menus.removeChild(ui_com);
				loader.unloadAndStop();
				p_travel.menu_count-=1;
			
			});
		
		}
		public function get pop_menus():Canvas{
			
			return viewComponent as Canvas;
		
		}
		
	}
}
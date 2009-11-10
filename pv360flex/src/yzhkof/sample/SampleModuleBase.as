package yzhkof.sample
{
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.modules.Module;
	
	import view.PopMenusFlex;
	
	import yzhkof.loader.CompatibleURLLoader;

	public class SampleModuleBase extends Module implements ISampleModule
	{
		private var hot_point_xml:XML;
		private var loader:CompatibleURLLoader;
		public function SampleModuleBase()
		{
			super();
			init();
		}
		private function init():void{
			loader=new CompatibleURLLoader();
			loader.loadURL("xml/hotpoints.xml");
			loader.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void{
			hot_point_xml=new XML(loader.data);
			initAPI();
		}
		private function initAPI():void{
			MainSystem.getInstance().addAPI("showSample",showSample);
			MainSystem.getInstance().addAPI("getSampleName",getSampleName);
		}
		public function getSampleName(id:String):String{
			return new XML(getHotPointXmlById(id)).@name;
		}
		public function showSample(id:String):void{
			var xml_string:String=getHotPointXmlById(id);
			var menu:PopMenusFlex=PopUpManager.createPopUp(DisplayObject(Application.application),PopMenusFlex,true) as PopMenusFlex;
			menu.addEventListener(FlexEvent.CREATION_COMPLETE,function(e:Event):void{
				menu.constructByXml(new XML(xml_string));
			});
			PopUpManager.centerPopUp(menu);
			menu.addEventListener(CloseEvent.CLOSE,onClose);
		}
		private function getHotPointXmlById(id:String):String{
			return hot_point_xml.HotPoint.(@id==id).toXMLString();
		}
		private function onClose(e:Event):void{
			PopUpManager.removePopUp(PopMenusFlex(e.currentTarget));
		}
	}
}
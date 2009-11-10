package yzhkof.sample
{
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.modules.Module;
	
	import view.PopMenusFlex;
	
	import yzhkof.loader.CompatibleURLLoader;

	public class SampleModuleBase extends Module
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
		}
		private function showSample(id:String):void{
			var menu:PopMenusFlex=PopUpManager.createPopUp(DisplayObject(Application.application),PopMenusFlex,true) as PopMenusFlex;
			//var menu:PopMenusFlex=new PopMenusFlex()
			menu.initialize();
			menu.constructByXml(new XML(hot_point_xml.HotPoint.(@id==id).toXMLString()));
			menu.addEventListener(CloseEvent.CLOSE,onClose);			
		}
		private function onClose(e:Event):void{
			PopUpManager.removePopUp(PopMenusFlex(e.currentTarget));
		}
	}
}
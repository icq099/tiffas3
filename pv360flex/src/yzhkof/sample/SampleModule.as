package yzhkof.sample
{
	import communication.MainSystem;
	
	import flash.events.Event;
	
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.modules.Module;
	
	import view.PopMenusFlex;
	
	import yzhkof.loader.CompatibleURLLoader;

	public class SampleModule extends Module
	{
		private var hot_point_xml:XML;
		private var loader:CompatibleURLLoader;
		public function SampleModule()
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
			hot_point_xml=loader.data as XML;
			initAPI();
		}
		private function initAPI():void{
			MainSystem.getInstance().addAPI("showSample",showSample);
		}
		private function showSample(id:String):void{
			var menu:PopMenusFlex=new PopMenusFlex();
			menu.constructByXml(new XML(hot_point_xml.HotPoint.(@id==id).toXMLString()));
			menu.addEventListener(CloseEvent.CLOSE,onClose);
			PopUpManager.centerPopUp(menu);
		}
		private function onClose(e:Event):void{
			PopUpManager.removePopUp(IFlexDisplayObject(e.currentTarget));
		}
	}
}
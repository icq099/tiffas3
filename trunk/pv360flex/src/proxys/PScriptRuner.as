package proxys
{
	import facades.FacadePv;
	
	import mediators.PluginMediator;
	
	public class PScriptRuner extends PScriptRunerBase
	{
		protected var p_xml:PXml;
		public function PScriptRuner()
		{
			super();
			p_xml=facade.retrieveProxy(PXml.NAME) as PXml
		}
		protected override function init():void{
			super.init();
			addAPI("gotoScene",gotoScene);
			addAPI("popUpHotPoint",popUpHotPoint);
			addAPI("showPluginById",showPluginById);
			addAPI("removePluginById",removePluginById);
		} 
		private function gotoScene(scene:int):void{
			facade.sendNotification(FacadePv.GO_POSITION,scene);
		}
		private function popUpHotPoint(id:int):void{
			facade.sendNotification(FacadePv.POPUP_MENU_DIRECT,id);
		}
		private function showPluginById(id:int):void{
			facade.sendNotification(PluginMediator.SHOW_PLUGIN,p_xml.getPluginXmlById(id));
		}
		private function removePluginById(id:int):void{
			facade.sendNotification(PluginMediator.REMOVE_PLUGIN,p_xml.getPluginXmlById(id));
		}
	}
}
package proxys
{
	import communication.MainSystem;
	import communication.camera.CameraProxy;
	
	import facades.FacadePv;
	
	import mediators.PluginMediator;
	
	public class PScriptRuner extends PScriptRunerBase
	{
		protected var p_xml:PXml;
		protected var p_travel:PTravel;
		public function PScriptRuner()
		{
			super();
			p_xml=facade.retrieveProxy(PXml.NAME) as PXml;
			p_travel=facade.retrieveProxy(PTravel.NAME) as PTravel;
			MainSystem.getInstance().camera=new CameraProxy(p_travel.getCamera());
		}
		protected override function init():void{
			super.init();
			addAPI("gotoScene",gotoScene);
			addAPI("popUpHotPoint",popUpHotPoint);
			addAPI("showPluginById",showPluginById);
			addAPI("removePluginById",removePluginById);
			addAPI("setCameraRotaion",setCameraRotaion);
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
		private function setCameraRotaion(rotaX:Number=0,rotaY:Number=0):void{
			var s_obj:Object={x:rotaX,y:rotaY,tween:true};
			facade.sendNotification(FacadePv.CAMERA_ROTA_DIRECT,s_obj);
		}
	}
}
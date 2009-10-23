package proxys
{
	import communication.Event.MainSystemEvent;
	import communication.Event.SceneChangeEvent;
	import communication.MainSystem;
	import communication.camera.CameraProxy;
	
	import facades.FacadePv;
	
	import mediators.AppMediator;
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
			MainSystem.getInstance().dispatchEvent(new MainSystemEvent(MainSystemEvent.INIT,new CameraProxy(p_travel.getCamera()),runer));
		}
		protected override function init():void{
			super.init();
			addAPI("gotoScene",gotoScene);
			addAPI("showPluginById",showPluginById);
			addAPI("removePluginById",removePluginById);
			addAPI("setCameraRotaion",setCameraRotaion);
			addAPI("fullScreen",fullScreen);
			addAPI("normalScreen",normalScreen);
			addAPI("setCameraFocus",setCameraFocus);
			addAPI("startRender",startRender);
			addAPI("stopRender",stopRender);
		}
		public function onSceneChangeComplete(scene_id:int):void{
			MainSystem.getInstance().dispatchEvent(new SceneChangeEvent(SceneChangeEvent.CHANGE,scene_id));
		}
		private function fullScreen():void{
			facade.sendNotification(AppMediator.FULL_SCREEM);
		}
		private function normalScreen():void{
			facade.sendNotification(AppMediator.NORMAL_SCREEM);
		}
		private function gotoScene(scene:int):void{
			facade.sendNotification(FacadePv.GO_POSITION,scene);
		}
		private function showPluginById(id:String):void{
			facade.sendNotification(PluginMediator.SHOW_PLUGIN,p_xml.getPluginXmlById(id));
		}
		private function removePluginById(id:String):void{
			facade.sendNotification(PluginMediator.REMOVE_PLUGIN,p_xml.getPluginXmlById(id));
		}
		private function setCameraFocus(value:Number):void{
			p_travel.cameraFocus=value;
		}
		private function setCameraRotaion(rotaX:Number=0,rotaY:Number=0):void{
			var s_obj:Object={x:rotaX,y:rotaY,tween:true};
			facade.sendNotification(FacadePv.CAMERA_ROTA_DIRECT,s_obj);
		}
		private function startRender():void{
			facade.sendNotification(FacadePv.START_RENDER);
		}
		private function stopRender():void{
			facade.sendNotification(FacadePv.STOP_RENDER);
		}
		private function updataScene():void{
			facade.sendNotification(FacadePv.UPDATA_SCENE);
		}
	}
}
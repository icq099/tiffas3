package proxys
{
	import communication.MainSystem;
	
	import facades.FacadePv;
	
	import model.Travel;
	
	import mx.managers.BrowserManager;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PTravel extends Proxy implements IProxy
	{
		
		public static const NAME:String="PTravel"
		
		
		private var _old_position:int=0;
		public function PTravel()
		{
			data=new Travel();
			super(NAME, data);
			
		}
		public function set oldPosition(value:int):void
		{
			_old_position=value;
		}
		public function get oldPosition():int{
			return _old_position;
		}
		public function get currentPosition():int{
			
			return travel.current_scene;
		
		}
		public function set currentPosition(value:int):void{
			
			travel.current_scene=value;
		
		}
		public function getCamera():FreeCamera3D{
			
			return FreeCamera3D(travel.camera);
		
		}
		public function setCameraRotaion(rotaX:Number=0,rotaY:Number=0,tween:Boolean=true):void{
			
			var s_obj:Object={x:rotaX,y:rotaY,tween:tween};
			facade.sendNotification(FacadePv.CAMERA_ROTA_DIRECT,s_obj);
		
		}
		public function set cameraFocus(focus:Number):void{
			
			travel.camera.focus=focus;
			facade.sendNotification(FacadePv.UPDATA_SCENE);
		
		}
		public function get cameraFocus():Number{
			
			return travel.camera.focus;
		
		}
		public function changePosition(postition:int):void{
			MainSystem.getInstance().dispatcherSceneChangeInit(postition);
			if((MainSystem.getInstance().currentScene!=postition)&&(travel.menu_count<=0)&&(!MainSystem.getInstance().isBusy)){
				MainSystem.getInstance().isBusy=true;
				oldPosition=MainSystem.getInstance().currentScene;
				MainSystem.getInstance().currentScene=postition;
				facade.sendNotification(FacadePv.POSITION_CHANGE_COMMAND,oldPosition);
				BrowserManager.getInstance().setFragment("scene="+postition);
			}
		}
		public function get travel():Travel{
			
			return data as Travel;
		
		}
	}
}
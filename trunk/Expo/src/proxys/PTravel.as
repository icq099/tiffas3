package proxys
{
	import facades.FacadePv;
	
	import model.Travel;
	
	import mx.managers.BrowserManager;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PTravel extends Proxy implements IProxy
	{
		
		public static const NAME:String="PTravel"
		
		private var _position_changing:Boolean=false;
		
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
			if((travel.current_scene!=postition)&&(travel.menu_count<=0)&&(!_position_changing)){
				_position_changing=true;
				facade.sendNotification(FacadePv.POSITION_CHANGE_COMMAND,postition);
				oldPosition=travel.current_scene;
				travel.current_scene=postition;
				BrowserManager.getInstance().setFragment("scene="+postition);
				
			}
		
		}
		public function set position_changing(value:Boolean):void{
			
			_position_changing=value;
		
		}
		public function get position_changing():Boolean{
			
			return _position_changing;
		
		}
		public function get travel():Travel{
			
			return data as Travel;
		
		}
	}
}
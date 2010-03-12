package commands
{
	import communication.MainSystem;
	
	import facades.FacadePv;
	
	import flash.events.Event;
	
	import mediators.PvSceneMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PTravel;
	import proxys.PXml;
	
	import yzhkof.CameraRotationControler;
	import yzhkof.CamereaControlerEvent;

	public class PositionChangeCommand extends SimpleCommand
	{
		private var travel:PTravel;
		private var xml:XML;
		private var movie:String;
		private var goto:int;
		private var stop_rotationX:Number;
		private var stop_rotationY:Number;
		
		public function PositionChangeCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			
			setValue(notification);
			
			var xml_movie:XMLList;
			var camera_rota:Object;
			
			goto=notification.getBody() as int;
			
			if(travel.currentPosition!=-1){
				
				xml_movie=xml.Travel.Scene[travel.currentPosition].Movie
				//for each (var item:int in str){
				for(var i:int=0;i<xml_movie.length();i++){
					
					var d_num:int=xml_movie[i].@destination;
					
					if(d_num==notification.getBody()){
						
						movie=xml_movie[i].@url;
						stop_rotationX=xml_movie[i].@stop_rotationX;
						stop_rotationY=xml_movie[i].@stop_rotationY;
						camera_rota={x:xml_movie[i].@start_rotationX,y:xml_movie[i].@start_rotationY}
						break;
					
					}
				
				}
				
			}
			
			
			
			if(movie==null){
				
				facade.sendNotification(FacadePv.POSITION_CHANGE,notification.getBody());
			
			}else{
				
				travel.setCameraRotaion(camera_rota.x-travel.getCamera().rotationX,camera_rota.y-travel.getCamera().rotationY);
				var controler:CameraRotationControler=PvSceneMediator(facade.retrieveMediator(PvSceneMediator.NAME)).controler;
				controler.addEventListener(CamereaControlerEvent.UPDATAED,onCameraUpdataed)
				facade.sendNotification(FacadePv.COVER_ENABLE);
			
			}
		
		}
		private function setValue(notification:INotification):void{
			
			xml=new XML(facade.retrieveProxy(PXml.NAME).getData());
			travel=facade.retrieveProxy(PTravel.NAME) as PTravel;
		
		}
		private function onCameraUpdataed(e:Event):void{
			
			sendNotificationCommand();
			e.currentTarget.removeEventListener(CamereaControlerEvent.UPDATAED,onCameraUpdataed);
		
		}
		private function sendNotificationCommand():void{
//			MainSystem.getInstance().runScript(movie);
			facade.sendNotification(FacadePv.LOAD_MOVIE,{url:movie,goto:goto,stop_rotationX:stop_rotationX,stop_rotationY:stop_rotationY});
//			facade.sendNotification(FacadePv.STOP_RENDER);
		
		}
		
	}
}
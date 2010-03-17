package commands
{
	import communication.MainSystem;
	
	import facades.FacadePv;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import gs.TweenMax;
	
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
		private var inquire:int;
		private var animationId:int;
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
						inquire=xml_movie[i].@inquire;
						animationId=xml_movie[i].@animationId;
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
			
			handleNotificationCommand();
			e.currentTarget.removeEventListener(CamereaControlerEvent.UPDATAED,onCameraUpdataed);
		
		}
		private function handleNotificationCommand():void
		{
			if(inquire==1)
			{
				facade.sendNotification(FacadePv.STOP_RENDER);
				MainSystem.getInstance().runAPIDirect("showGuiWa",[animationId,true]);
				var dis:DisplayObject=MainSystem.getInstance().getPlugin("AnimationModule");
				if(dis!=null)
				{
					dis.addEventListener(Event.OPEN,function(e:Event):void{
						facade.sendNotification(FacadePv.START_RENDER);
						sendNotificationCommand();
					});
					dis.addEventListener(Event.CLOSE,function(e:Event):void{
						facade.sendNotification(FacadePv.START_RENDER);
						var travel:PTravel=facade.retrieveProxy(PTravel.NAME) as PTravel;
						travel.position_changing=false;
						travel.currentPosition=travel.oldPosition;
					});
				}
			}else
			{
				sendNotificationCommand();
			}
		}
		private function sendNotificationCommand():void{
			facade.sendNotification(FacadePv.STOP_RENDER);
            if(movie.charAt(0)=="m" && movie.charAt(1)=="o" && movie.charAt(2)=="v" && movie.charAt(3)=="i" && movie.charAt(4)=="e")
            {
            	facade.sendNotification(FacadePv.LOAD_MOVIE,{url:movie,goto:goto,stop_rotationX:stop_rotationX,stop_rotationY:stop_rotationY});
            }
            else
            {
            	MainSystem.getInstance().runScript(movie);
            }
//			facade.sendNotification(FacadePv.STOP_RENDER);
		}
		
	}
}
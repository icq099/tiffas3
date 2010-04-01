package commands
{
	import communication.Event.PluginEvent;
	import communication.Event.ScriptAPIAddEvent;
	import communication.MainSystem;
	
	import facades.FacadePv;
	
	import flash.events.Event;
	
	import lxfa.utils.BackGroundMusicManager;
	
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
		private var oldPosition:int;
		private var stop_rotationX:Number;
		private var stop_rotationY:Number;
		
		public function PositionChangeCommand()
		{
			super();
		}
		private static var num:int=0;
		override public function execute(notification:INotification):void{
			setValue(notification);
			var xml_movie:XMLList;
			var camera_rota:Object;
			oldPosition=notification.getBody() as int;
			if(MainSystem.getInstance().currentScene!=-1 && oldPosition<xml.Travel.Scene.length()){
				xml_movie=xml.Travel.Scene[oldPosition].Movie
				//for each (var item:int in str){
				for(var i:int=0;i<xml_movie.length();i++){
					
					var d_num:int=xml_movie[i].@destination;
					if(d_num==MainSystem.getInstance().currentScene){
						
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
				facade.sendNotification(FacadePv.POSITION_CHANGE, MainSystem.getInstance().currentScene);
			
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
			//罗盘旋转完毕就开始抛出插件刷新的事件
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));//抛出插件刷新的事件
			MainSystem.getInstance().dispatcherSceneChangeInit(MainSystem.getInstance().currentScene);
			if(inquire==1)
			{
				facade.sendNotification(FacadePv.STOP_RENDER);
				MainSystem.getInstance().isBusy=false;
				MainSystem.getInstance().showPluginById("InquireModule");
				MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.ADD_API,added);
			}else
			{
				sendNotificationCommand();
			}
		}
		private function added(e:ScriptAPIAddEvent):void//showInquire指令添加完毕就显示询问窗口并添加窗口的监听事件
		{
			if(e.fun_name=="showInquire")
			{
				MainSystem.getInstance().runAPIDirect("showInquire",[animationId]);
				MainSystem.getInstance().isBusy=true;
				MainSystem.getInstance().getPlugin("InquireModule").addEventListener(Event.OPEN,open);
				MainSystem.getInstance().getPlugin("InquireModule").addEventListener(Event.CLOSE,close);
				MainSystem.getInstance().removeEventListener(ScriptAPIAddEvent.ADD_API,added);
			}
		}
		private function open(e:Event):void
		{
			sendNotificationCommand();
			MainSystem.getInstance().getPlugin("InquireModule").removeEventListener(Event.CLOSE,close);//删除监听关闭东西的事件
			MainSystem.getInstance().getPlugin("InquireModule").removeEventListener(Event.OPEN,open);//删除监听打开东西的事件
		}
		private function close(e:Event):void
		{
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().startRender();
			BackGroundMusicManager.getInstance().reload();
			var travel:PTravel=facade.retrieveProxy(PTravel.NAME) as PTravel;
			MainSystem.getInstance().currentScene=travel.oldPosition;
			MainSystem.getInstance().getPlugin("InquireModule").removeEventListener(Event.CLOSE,close);//删除监听关闭东西的事件
			MainSystem.getInstance().getPlugin("InquireModule").removeEventListener(Event.OPEN,open);//删除监听打开东西的事件
			MainSystem.getInstance().isBusy=false;
		}
		private function sendNotificationCommand():void{
			facade.sendNotification(FacadePv.STOP_RENDER);
			MainSystem.getInstance().isBusy=true;
            if(movie.charAt(0)=="m" && movie.charAt(1)=="o" && movie.charAt(2)=="v" && movie.charAt(3)=="i" && movie.charAt(4)=="e")
            {
            	facade.sendNotification(FacadePv.LOAD_MOVIE,{url:movie,goto:MainSystem.getInstance().currentScene,stop_rotationX:stop_rotationX,stop_rotationY:stop_rotationY});
            }
            else
            {
            	if(MainSystem.getInstance().isBusy)
            	{
	            	MainSystem.getInstance().isBusy=false;
	            	MainSystem.getInstance().runScript(movie);
	            	MainSystem.getInstance().isBusy=true;
            	}
            	else
            	{
            		MainSystem.getInstance().runScript(movie);
            	}
            } 
		}
		
	}
}
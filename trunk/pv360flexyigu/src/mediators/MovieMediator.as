package mediators
{
	import facades.FacadePv;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxys.PTravel;
	
	import view.MovieViewer;

	public class MovieMediator extends Mediator
	{
		public static const NAME:String="MovieMediator";
		
		private var xml:XML;
		private var travel:PTravel;
		private var goto:int;
		private var stop_rotationX:Number;
		private var stop_rotationY:Number;
		
		public function MovieMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array{
			
			return [
			
				FacadePv.LOAD_XML_COMPLETE,
				FacadePv.LOAD_MOVIE,
				FacadePv.COVER_ENABLE,
				FacadePv.COVER_DISABLE,
				FacadePv.REMOVE_MOVIE
			
			]
		
		}
		override public function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case FacadePv.LOAD_XML_COMPLETE:
				
					xml=new XML(notification.getBody());
					travel=facade.retrieveProxy(PTravel.NAME) as PTravel;
				
				break;
				case FacadePv.LOAD_MOVIE:
				
					movie_viewer.loadMovie(String(notification.getBody().url));	
					movie_viewer.addEventListener(Event.COMPLETE,onMovieCompleteHandler);	
					goto=notification.getBody().goto;
					stop_rotationX=notification.getBody().stop_rotationX;
					stop_rotationY=notification.getBody().stop_rotationY;
				
				break;
				case FacadePv.COVER_ENABLE:
				
					movie_viewer.enableCover();
				
				break;
				case FacadePv.COVER_DISABLE:
				
					movie_viewer.disableCover();
				
				break;
				case FacadePv.REMOVE_MOVIE:
				
					movie_viewer.disappear();
				
				break;
			
			
			}
		}
		private function onMovieCompleteHandler(e:Event):void{
			
			facade.sendNotification(FacadePv.POSITION_CHANGE,goto);
			//facade.sendNotification(FacadePv.COVER_DISABLE);
			//facade.sendNotification(FacadePv.START_RENDER);
			
			travel.setCameraRotaion(stop_rotationX-travel.getCamera().rotationX,stop_rotationY-travel.getCamera().rotationY,false)
		
		}
		public function get movie_viewer():MovieViewer{
			
			return viewComponent as MovieViewer;
		
		}
		
	}
}
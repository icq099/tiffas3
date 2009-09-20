package mediators
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AppMediator extends Mediator
	{
		public static const NAME:String="AppMediator";
		
		public static const ADD_CHILD:String="AppMediator_ADD_CHILD";
		public static const DISPATCH_EVENT:String="AppMediator_DISPATCH_EVENT";
		
		public function AppMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array{
			
			return[
			
				AppMediator.ADD_CHILD,
				AppMediator.DISPATCH_EVENT
			
			];
		
		}
		override public function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case AppMediator.ADD_CHILD:
				
					app.addChild(DisplayObject(notification.getBody()));
				
				break;
				case AppMediator.DISPATCH_EVENT:
				
					app.dispatchEvent(Event(notification.getBody()));
				
				break;				
			}
			
		}
		private function get app():DisplayObjectContainer{
			
			return viewComponent as DisplayObjectContainer
		
		}
	}
}
package mediators
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.SubTitle;

	public class SubTitleMediator extends Mediator
	{
		public static const NAME:String="SubTitleMediator";
		public static const CHANGE_TEXT:String="CHANGE_TEXT";
		
		public function SubTitleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public override function listNotificationInterests():Array{
			
			return [
				SubTitleMediator.CHANGE_TEXT								
			];
		
		}
		public override function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case SubTitleMediator.CHANGE_TEXT:
				
					sub_title.text=String(notification.getBody());
				
				break;
			
			}
			
		}
		private function get sub_title():SubTitle{
			
			return viewComponent as SubTitle;
		
		}
		
	}
}
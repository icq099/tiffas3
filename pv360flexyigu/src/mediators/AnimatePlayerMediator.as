package mediators
{
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.AnimatePlayer;

	public class AnimatePlayerMediator extends Mediator
	{
		public static const NAME:String="AnimatePlayerMediator";
		public static const CHANGE_SWF:String="CHANGE_SWF";
		public static const SHOW_ANIMATE:String="SHOW_ANIMATE";
		public static const HIDE_ANIMATE:String="HIDE_ANIMATE";
		
		public function AnimatePlayerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public override function listNotificationInterests():Array{
			
			return [
			
				AnimatePlayerMediator.CHANGE_SWF,
				AnimatePlayerMediator.SHOW_ANIMATE,
				AnimatePlayerMediator.HIDE_ANIMATE
			
			];
		
		}
		public override function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case AnimatePlayerMediator.CHANGE_SWF:
				
					if(notification.getBody()!==null){
						
						animate_player.animateLoad(String(notification.getBody()));
						
					}else{
					
					}
				
				break;
				case AnimatePlayerMediator.SHOW_ANIMATE:
				
					animate_player.openAnimate();
				
				break;
				case AnimatePlayerMediator.HIDE_ANIMATE:
				
					animate_player.closeAnimate();
				
				break;
			
			}
		}
		public function get animate_player():AnimatePlayer{
			
			return viewComponent as AnimatePlayer;
		
		}
		
	}
}
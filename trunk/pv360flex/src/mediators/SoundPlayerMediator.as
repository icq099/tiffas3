package mediators
{
	import facades.FacadePv;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.ExhibitSound;

	public class SoundPlayerMediator extends Mediator
	{
		public static const NAME:String="SoundPlayerMediator";
		public static const PAUSE_SOUND:String="PAUSE_SOUND";
		public static const RESUME_SOUND:String="RESUME_SOUND";
		
		public function SoundPlayerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public override function listNotificationInterests():Array{
			
			return [
			
				FacadePv.LOAD_XML_COMPLETE,
				SoundPlayerMediator.PAUSE_SOUND,
				SoundPlayerMediator.RESUME_SOUND
			
				];
		
		}
		public override function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case FacadePv.LOAD_XML_COMPLETE:
				
					var xml:XML=new XML(notification.getBody());
					initEffect();
					loadSound(xml.Travel.@music);
					playerBar.allowRepeat=true;
				
				break;
				case SoundPlayerMediator.PAUSE_SOUND:
				
					playerBar.pause();
				
				break;
				case SoundPlayerMediator.RESUME_SOUND:
				
					playerBar.resume();
					
				break;
			
			}
		
		}
		private function initEffect():void{
			
			playerBar.toolTip="背景音乐";
			
			playerBar.scaleX=1.5;
			playerBar.scaleY=1.5;
			playerBar.addEventListener(MouseEvent.ROLL_OVER,function(e:Event):void{
				
				TweenLite.to(playerBar,0.2,{scaleX:2,scaleY:2});
			
			});
			playerBar.addEventListener(MouseEvent.ROLL_OUT,function(e:Event):void{
				
				TweenLite.to(playerBar,0.2,{scaleX:1.5,scaleY:1.5,delay:1});
			
			})
		
		}
		public function get playerBar():ExhibitSound{
			
			return viewComponent as ExhibitSound;
		
		}
		private function loadSound(url:String):void{
			
			playerBar.changeSound(url);			
		
		}
		
	}
}
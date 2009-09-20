package commands
{
	import facades.FacadePv;
	
	import mediators.AnimatePlayerMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class AnimatePlayerShowAnimateCommand extends SimpleCommand
	{
		public function AnimatePlayerShowAnimateCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			
			facade.sendNotification(AnimatePlayerMediator.SHOW_ANIMATE);
			facade.removeCommand(FacadePv.LOAD_XML_COMPLETE);
		
		}
	}
}
package commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PTravel;

	public class GoPositionCommand extends SimpleCommand
	{
		public function GoPositionCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			
			var travel:PTravel=facade.retrieveProxy(PTravel.NAME) as PTravel;
			travel.changePosition(int(notification.getBody()));
		
		}
		
	}
}
package commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PTravel;

	public class SetProxyChangeComplete extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void{
			
			var p_travel:PTravel=facade.retrieveProxy(PTravel.NAME) as PTravel;
			p_travel.position_changing=false;
		
		}
		
	}
}
package commands
{
	import communication.MainSystem;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PScriptRuner;
	import proxys.PScriptRunerBase;
	import proxys.PTravel;

	public class SetProxyChangeComplete extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void{
			
			var p_travel:PTravel=facade.retrieveProxy(PTravel.NAME) as PTravel;
			var p_runer:PScriptRuner=facade.retrieveProxy(PScriptRunerBase.NAME) as PScriptRuner;
			p_runer.onSceneChangeComplete(p_travel.currentPosition);
			MainSystem.getInstance().isBusy=false;
		}
		
	}
}
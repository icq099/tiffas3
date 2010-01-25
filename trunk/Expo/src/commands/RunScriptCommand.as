package commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PScriptRuner;

	public class RunScriptCommand extends SimpleCommand
	{
		public function RunScriptCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			var p_runer:PScriptRuner=facade.retrieveProxy(PScriptRuner.NAME);
			p_runer.runScript(String(notification.getBody()));		
		}
		
	}
}
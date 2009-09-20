package commands
{
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class PositionChangeCompleteCommand extends MacroCommand
	{
		public function PositionChangeCompleteCommand()
		{
			super();
			
		}
		override protected function initializeMacroCommand():void{
			
			addSubCommand(AnimatePlayerChangeCommand);
			addSubCommand(SubTitleChangeCommand);
			addSubCommand(SetProxyChangeComplete);
		
		}
		
	}
}
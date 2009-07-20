package commands
{
	import mediators.AnimatePlayerMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PXml;

	public class AnimatePlayerChangeCommand extends SimpleCommand
	{
		private var p_xml:PXml;
		public function AnimatePlayerChangeCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			
			p_xml=facade.retrieveProxy(PXml.NAME) as PXml;
			facade.sendNotification(AnimatePlayerMediator.CHANGE_SWF,p_xml.getGuideSwf(String(notification.getBody())));
		
		}
		
	}
}
package commands
{
	import mediators.MapMediator;
	import mediators.SubTitleMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PXml;

	public class SubTitleChangeCommand extends SimpleCommand
	{
		public function SubTitleChangeCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			
			var goto:int=notification.getBody() as int;
			
			var sub_title_text:String=PXml(facade.retrieveProxy(PXml.NAME)).getMapTextBySceneId(goto);
			
			facade.sendNotification(SubTitleMediator.CHANGE_TEXT,sub_title_text);
			facade.sendNotification(MapMediator.TEXT_CHANGE,sub_title_text);
		
		}
		
	}
}
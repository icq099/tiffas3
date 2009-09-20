package commands
{

	import facades.FacadePv;
	
	import flash.display.Sprite;
	
	import mediators.AppMediator;
	import mediators.MapMediator;
	import mediators.PvSceneMediator;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PTravel;
	import proxys.PXml;
	
	import yzhkof.AddToStageSetter;
	import yzhkof.Toolyzhkof;

	public class StartupCommand extends SimpleCommand implements ICommand
	{
		private var app:Sprite;
		
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{	
			app=Sprite(notification.getBody());
			
			var loaderskin:LoadingSimpleRota=new LoadingSimpleRota();
			var loader:UIComponent=Toolyzhkof.mcToUI(loaderskin);
			AddToStageSetter.setObjToMiddleOfStage(loaderskin,loaderskin.width/2,loaderskin.height/2);
			
			app.addChild(loader);
			
			facade.registerProxy(new PTravel());
			facade.registerProxy(new PXml());
			
			facade.registerCommand(FacadePv.INIT_DISPLAY,InitDisplayCommand);
			facade.registerCommand(FacadePv.POSITION_CHANGE_COMMAND,PositionChangeCommand);
			facade.registerCommand(FacadePv.GO_POSITION,GoPositionCommand);
			facade.registerCommand(PvSceneMediator.PICTURE_LOAD_COMPLETE,PositionChangeCompleteCommand);
			facade.registerCommand(MapMediator.HELP_CLICK,AnimatePlayerShowAnimateCommand);
			facade.registerCommand(FacadePv.LOAD_XML_COMPLETE,AnimatePlayerShowAnimateCommand);
			facade.registerCommand(FacadePv.PRE_INIT_LOAD,PreInitLoadCommand);
			
			facade.registerMediator(new AppMediator(app));
			
			PXml(facade.retrieveProxy(PXml.NAME)).loadXml();
			
			facade.removeCommand(FacadePv.STARTUP);
			
		}
		
	}
}
package commands
{
	import br.com.stimuli.loading.BulkLoader;
	
	import facades.FacadePv;
	
	import flash.events.Event;
	
	import mediators.AppMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PScriptRuner;
	import proxys.PScriptRunerBase;
	import proxys.PTravel;
	import proxys.PXml;

	public class PreInitLoadCommand extends SimpleCommand
	{
		private var loader:BulkLoader=new BulkLoader("preload");
		public function PreInitLoadCommand()
		{
			super();
		}
		/* override public function execute(notification:INotification):void{
			
			var preload_array:Array=notification.getBody() as Array;
			
			for each(var i:String in preload_array){
				
				loader.add(i)
			
			}
			loader.start();
			loader.addEventListener(BulkProgressEvent.COMPLETE,onCompleteHandler);
					
		} */
		override public function execute(notification:INotification):void{
			
			var p_xml:PXml=PXml(facade.retrieveProxy(PXml.NAME));
			var p_script:PScriptRuner=PScriptRuner(facade.retrieveProxy(PScriptRunerBase.NAME));
			var p_travel:PTravel=PTravel(facade.retrieveProxy(PTravel.NAME));
			p_travel.getCamera().rotationY=p_xml.xml.Travel.@stop_rotationY;
			p_travel.getCamera().rotationX=p_xml.xml.Travel.@stop_rotationX;
			
			loader.clear();
			
			facade.sendNotification(FacadePv.INIT_DISPLAY);
			facade.sendNotification(FacadePv.LOAD_XML_COMPLETE,p_xml.getData());
			facade.sendNotification(AppMediator.DISPATCH_EVENT,new Event("display_show",true));
			
			p_script.runScript(p_xml.getInitScript());
		}
	}
}
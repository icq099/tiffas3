package commands
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import facades.FacadePv;
	
	import flash.events.Event;
	
	import mediators.AppMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PTravel;
	import proxys.PXml;

	public class PreInitLoadCommand extends SimpleCommand
	{
		private var loader:BulkLoader=new BulkLoader("preload");
		public function PreInitLoadCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			
			var preload_array:Array=notification.getBody() as Array;
			
			for each(var i:String in preload_array){
				
				loader.add(i)
			
			}
			loader.start();
			loader.addEventListener(BulkProgressEvent.COMPLETE,onCompleteHandler);
					
		}
		private function onCompleteHandler(e:Event=null):void{
			
			var p_xml:PXml=PXml(facade.retrieveProxy(PXml.NAME));
			
			loader.clear();
			
			facade.sendNotification(FacadePv.INIT_DISPLAY);
			facade.sendNotification(FacadePv.LOAD_XML_COMPLETE,p_xml.getData());
			facade.sendNotification(AppMediator.DISPATCH_EVENT,new Event("display_show",true));
			
			var xml_travel:XMLList=p_xml.getXml().Travel;
			
			if(!p_xml.getUrlObject().hasOwnProperty("scene")){
			
				if(xml_travel.@openingMovie.length()>0){
					
					facade.sendNotification(FacadePv.LOAD_MOVIE,{url:xml_travel.@openingMovie,goto:xml_travel.@start_scene,stop_rotationX:xml_travel.@stop_rotationX,stop_rotationY:xml_travel.@stop_rotationY});
					PTravel(facade.retrieveProxy(PTravel.NAME)).currentPosition=int(xml_travel.@start_scene);
					
				}else{
				
					PTravel(facade.retrieveProxy(PTravel.NAME)).changePosition(p_xml.getStartPosition());
					
				}
				
			}else{
				
				PTravel(facade.retrieveProxy(PTravel.NAME)).changePosition(int(p_xml.getUrlObject().scene));			
			
			}
		
		}
	}
}
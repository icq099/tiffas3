package facades
{
	import commands.StartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class FacadePv extends Facade implements IFacade
	{
		public static const STARTUP:String= "STARTUP";
		public static const LOAD_XML_COMPLETE:String= "LOAD_XML_COMPLETE";
		public static const POSITION_CHANGE:String="POSITION_CHANGE";
		public static const POSITION_CHANGE_COMMAND:String="POSITION_CHANGE_COMMAND";
		public static const LOAD_MOVIE:String="LOAD_MOVIE";
		public static const CAMERA_ROTA_DIRECT:String="CAMERA_ROTA_DIRECT";
		public static const UPDATA_SCENE:String="UPDATA_SCENE";
		public static const HOT_POINT_CLICK:String="HOT_POINT_CLICK";
		public static const START_RENDER:String="START_RENDER";
		public static const STOP_RENDER:String="STOP_RENDER";
		public static const COVER_ENABLE:String="COVER_ENABLE";
		public static const COVER_DISABLE:String="COVER_DISABLE";
		public static const REMOVE_MOVIE:String="REMOVE_MOVIE";
		public static const POPUP_MENU_DIRECT:String="POPUP_MENU_DIRECT";
		public static const GO_POSITION:String="GO_POSITION";
		public static const INIT_DISPLAY:String="INIT_DISPLAY";
		public static const PRE_INIT_LOAD:String="PRE_INIT_LOAD";
		
		public function FacadePv()
		{
			super();
		}
		public static function getInstance() : FacadePv {
			
            if ( instance == null ) instance = new FacadePv();
            return instance as FacadePv;
            
        }
        public function startUp(app:Object):void{
        	
        	sendNotification(STARTUP,app)
        	
        }
        override protected function initializeController():void{
        	
        	super.initializeController();
        	registerCommand(STARTUP,StartupCommand);
        
        }		
		
		
	}
}
package mediators
{
	import facades.FacadePv;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import other.CameraEvent;
	
	import proxys.PTravel;
	import proxys.PXml;
	
	import view.MapDirector;

	public class MapMediator extends Mediator
	{
		public static const NAME:String="MapMediator";
		public static const HELP_CLICK:String="HELP_CLICK";
		public static const TEXT_CHANGE:String="MapMediator_TEXT_CHANGE";
		
		private var viewer:MapDirector;
		private var xml_map:XMLList;
		private var click_point_map:Object=new Object();
		
		public function MapMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			viewer=viewComponent as MapDirector;
			
		}
		override public function listNotificationInterests():Array{
			
			return[
			
			FacadePv.POSITION_CHANGE,
			FacadePv.LOAD_XML_COMPLETE,
			MapMediator.TEXT_CHANGE
			
			];
		
		}
		override public function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case FacadePv.LOAD_XML_COMPLETE:
				
				var xml:XML=new XML(notification.getBody());
				var xml_travel:XMLList=xml.Travel;
				var p_xml:PXml=facade.retrieveProxy(PXml.NAME) as PXml
				
				xml_map=xml.Map;
				//设定点击
				for(var i:int=0;i<xml_map.clickpoints.length();i++){
					
					click_point_map[xml_map.clickpoints.@destination[i]]=viewer.addClickPoint(xml_map.clickpoints.@x[i],xml_map.clickpoints.@y[i],xml_map.clickpoints[i].@tooltip);
					
					//设定点击监听
					if(xml_map.clickpoints[i].@url.length()>0){
						
						viewer.click_points[i].addEventListener(MouseEvent.CLICK,function(e:Event):void{
							
							navigateToURL(new URLRequest(xml_map.clickpoints[viewer.click_points.indexOf(e.currentTarget)].@url),"_self");
					
						});
					
					}else{
						
						viewer.click_points[i].addEventListener(MouseEvent.CLICK,function(e:Event):void{
							
							/* var pv_scene:Pv3d360Scene=facade.retrieveMediator(PvSceneMediator.NAME).getViewComponent() as Pv3d360Scene;
							pv_scene.changeBitmap(xml.Travel.Scene.@picture[int(xml_map.clickpoints.@destination[i])]);  */
							//var travel:PTravel=facade.retrieveProxy(PTravel.NAME) as PTravel;
							//travel.changePosition(xml_map.clickpoints.@destination[viewer.click_points.indexOf(e.currentTarget)]);
							facade.sendNotification(FacadePv.GO_POSITION,xml_map.clickpoints.@destination[viewer.click_points.indexOf(e.currentTarget)]);
					
						});
						
					}
					
				}
				//设定展项提示点
				for(var j:int=0;j<xml_map.exhibitpoints.length();j++){
					
					var text:String;
					var id:String=xml_map.exhibitpoints.@id[j];
					
					text=p_xml.getHotPointXmlById(id).@name;
					viewer.addExhibitPoint(xml_map.exhibitpoints.@x[j],xml_map.exhibitpoints.@y[j],text);
				
				}
				
				//设定地图
				viewer.setMap(xml_map.@picture);
				
				//设置监听
				viewer.addEventListener("help_click",function(e:Event):void{
					
					facade.sendNotification(MapMediator.HELP_CLICK);
				
				})
				
				PTravel(facade.retrieveProxy(PTravel.NAME)).getCamera().addEventListener(CameraEvent.CAMERA_ROTATION_CHANGE,cameraUpdateHandler);
				
				break;
				case FacadePv.POSITION_CHANGE:
				
					var position:int=notification.getBody() as int;
			
					viewer.setLookPosition(viewer.click_points.indexOf(click_point_map[position]));
				
				break;
				case MapMediator.TEXT_CHANGE:
				
					viewer.text=String(notification.getBody());
					
				break;
			
			}
		
		}
		private function cameraUpdateHandler(e:Event):void{
			
			viewer.look_rotationX=e.currentTarget.rotationX;
			viewer.look_rotationY=e.currentTarget.rotationY;
		
		}
		
	}
}
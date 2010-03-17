package mediators
{
	import communication.MainSystem;
	
	import facades.FacadePv;
	
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.events.Event;
	
	import gs.TweenLite;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.primitives.Plane;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxys.PScriptRuner;
	import proxys.PScriptRunerBase;
	import proxys.PTravel;
	import proxys.PXml;
	
	import view.Pv3d360Scene;
	
	import yzhkof.AddToStageSetter;
	import yzhkof.CameraRotationControler;
	import yzhkof.CamereaControlerEvent;
	import yzhkof.MyGC;

	public class PvSceneMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PvSceneMediator"
		public static const PICTURE_LOAD_COMPLETE:String="PICTURE_LOAD_COMPLETE";
		
		public var viewer:Pv3d360Scene;
		public var controler:CameraRotationControler;
		private var updata_type:String="";
		
		private var xml:XML;
		//private var travel:PTravel;
		private var pxml:PXml;
		
		public function PvSceneMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			viewer=viewComponent as Pv3d360Scene;
		}
		override public function listNotificationInterests():Array{
			
			return[
			
			FacadePv.LOAD_XML_COMPLETE,
			FacadePv.POSITION_CHANGE,
			FacadePv.CAMERA_ROTA_DIRECT,
			FacadePv.UPDATA_SCENE,
			FacadePv.START_RENDER,
			FacadePv.STOP_RENDER
			
			]; 
		
		}
		
		override public function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case FacadePv.LOAD_XML_COMPLETE:
				
					xml=new XML(notification.getBody());
					//travel=facade.retrieveProxy(PTravel.NAME) as PTravel;
					pxml=facade.retrieveProxy(PXml.NAME) as PXml;
					//var current_scene:int=xml.Travel.@start_scene;
					var compas_rota:Number=xml.Compass.@rotation;
					viewer.setCompassRotation(compas_rota);
					AddToStageSetter.delayExcuteAfterAddToStage(viewer,function():void{
						controler=new CameraRotationControler(viewer,PTravel(facade.retrieveProxy("PTravel")).getCamera());
						controler.addEventListener(CamereaControlerEvent.UPDATA,onCameraUpdata);
						controler.addEventListener(CamereaControlerEvent.UPDATAED,onCameraUpdataed);
						viewer.stage.addEventListener(Event.RESIZE,resizeHandler,false,0,true);
					});
					//travel.changePosition(current_scene);
					
				break;
				case FacadePv.POSITION_CHANGE:
					
					changePosition(notification.getBody() as int);
				
				break;
				case FacadePv.CAMERA_ROTA_DIRECT:
				
				if(notification.getBody().tween){
					
					controler.setGotoRotation(notification.getBody().x,notification.getBody().y);
					
				}else{
					
					controler.setRotation(notification.getBody().x,notification.getBody().y);
				
				}
				
				break;
				case FacadePv.UPDATA_SCENE:
				
					viewer.draw();
				
				break;
				case FacadePv.START_RENDER:
				
					viewer.startRend();
					if(controler!=null)
						controler.enable();
				
				break;
				case FacadePv.STOP_RENDER:
				
					viewer.stopRend();
					if(controler!=null)
						controler.disable();
				
				break;
			
			}
		
		}
		private function onCameraUpdata(e:Event):void{
			
			viewer.stage.quality=StageQuality.LOW;
			viewer.render_type=Pv3d360Scene.REND_ALL;
		
		}
		private function onCameraUpdataed(e:Event):void{
			viewer.stage.quality=StageQuality.HIGH;
			switch(updata_type){
				case "movieclip":
					viewer.render_type=Pv3d360Scene.REND_ALL;
				break;
				default:
					viewer.draw();
					viewer.render_type=Pv3d360Scene.REND_ANIMATE;
				break;
			}		
		}
		private function changePosition(goto:int):void{
			var complete_fun:Function=function():void{
				
				updataArrows(goto);
				updataHotPoints(goto);
				updataAnimates(goto);
				updataControler(goto);
				
				viewer.draw();
				
				facade.sendNotification(PvSceneMediator.PICTURE_LOAD_COMPLETE,goto);
				facade.sendNotification(FacadePv.COVER_DISABLE);
				//facade.sendNotification(FacadePv.START_RENDER);
				//手动回收
				MyGC.gc();
				facade.sendNotification(FacadePv.REMOVE_MOVIE);
				
			};
			var url:String=String(xml.Travel.Scene.@picture[goto]);
			var type:String=String(xml.Travel.Scene[goto].@type);
			updata_type=type;
			viewer.changeBitmap(url,type,complete_fun);
		}
		private function updataControler(position:int):void{
			
			var scene_xml:XML=xml.Travel.Scene[position];
			
			if(scene_xml.@rotationYMin.length()>0){
				
				controler.setLimit(scene_xml.@rotationYMin,scene_xml.@rotationYMax);
				
			}else{
				
				controler.unLimit();
			
			}
		
		}
		private function updataArrows(position:int):void{
			
			var xml_compass:XMLList=xml.Travel.Scene[position].Compass;
			
			viewer.cleanAllArrow();
			
			for(var i:int=0;i<xml_compass.Arrow.length();i++){
				
				var arrow:Plane=viewer.addArrow(xml_compass.Arrow.@rotation[i],xml_compass.Arrow[i].@tip);
				
				arrow.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,function(e:InteractiveScene3DEvent):void{
					var travel:PTravel=facade.retrieveProxy(PTravel.NAME) as PTravel;
					travel.changePosition(xml_compass.Arrow.@destination[viewer.arrows.indexOf(e.currentTarget)]);
				
				})
			
			}
		
		}
		private function updataAnimates(position:int):void{
			
			var xml_animate:XMLList=xml.Travel.Scene[position].Animate;
			var cache:Boolean;
			viewer.cleanAllAnimate();
			for(var i:int=0;i<xml_animate.length();i++){
				
				cache=xml_animate[i].@cache==1?true:false;				
				var plane:Plane=viewer.addAminate(xml_animate[i].@url,{x:xml_animate[i].@x,y:xml_animate[i].@y,z:xml_animate[i].@z,rotationX:xml_animate[i].@rotationX,rotationY:xml_animate[i].@rotationY,rotationZ:xml_animate[i].@rotationZ,width:xml_animate[i].@width,height:xml_animate[i].@height,segmentsW:xml_animate[i].@segmentsW,segmentsH:xml_animate[i].@segmentsH,offset:xml_animate[i].@offset,angle:xml_animate[i].@angle,force:xml_animate[i].@force,onClick:xml_animate[i].@onClick,visible:xml_animate[i].@visble},cache);
			}
		}
		private function updataHotPoints(position:int):void{
			
			//var xml_hot_point:XMLList=xml.Travel.Scene[position].HotPoint;
			viewer.cleanAllHotPoints();
			var hot_points_position:XMLList=pxml.getSceneHotPointsPositionXml(position);
			//var plugins_position:XMLList=pxml.getScenePluginPositionXml(position);
			var tip_text:String;
			var icon:BitmapData;
			var plane:Plane
			/* 
			//解析HotPoint标签
			for(var i:int=0;i<hot_points_position.length();i++){
				
				tip_text=pxml.getHotPointXmlById(hot_points_position.@id[i]).@name;
				//icon=pxml.getIconBitmapdataById(hot_points_position.@icon[i]);
				icon=ToolBitmapData.getInstance().drawDisplayObject(new SceneClickPoint(hot_points_position.@id[i]));
				plane=viewer.addHotPoint({x:hot_points_position.@x[i],y:hot_points_position.@y[i],z:hot_points_position.@z[i],width:hot_points_position.@width[i],height:hot_points_position.@height[i],segmentsW:hot_points_position.@segmentsW[i],segmentsH:hot_points_position.@segmentsH[i]},tip_text,icon,false);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,function(e:InteractiveScene3DEvent):void{
					
					facade.sendNotification(FacadePv.HOT_POINT_CLICK,viewer.hot_points.indexOf(e.currentTarget));
				
				});
			
			} */
			var p_runer:PScriptRuner=facade.retrieveProxy(PScriptRunerBase.NAME) as PScriptRuner;
			var onClickMap:Object=new Object();
			var onRollOverMap:Object=new Object();
			var onRollOutMap:Object=new Object();
			//解析HotPoint标签
			for(var i:int=0;i<hot_points_position.length();i++){
				
				tip_text=hot_points_position[i].@tip;
				icon=pxml.getIconBitmapdataById(hot_points_position.@icon[i]);
				plane=viewer.addHotPoint({x:hot_points_position.@x[i],y:hot_points_position.@y[i],z:hot_points_position.@z[i],width:hot_points_position.@width[i],height:hot_points_position.@height[i],segmentsW:hot_points_position.@segmentsW[i],segmentsH:hot_points_position.@segmentsH[i]},tip_text,icon);
				onClickMap[plane]=hot_points_position[i].@onClick;
				onRollOverMap[plane]=hot_points_position[i].@onRollOver;
				onRollOutMap[plane]=hot_points_position[i].@onRollOut;
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,function(e:InteractiveScene3DEvent):void{
					
					p_runer.runScript(onClickMap[Plane(e.currentTarget)]);
				
				});
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER,function(e:InteractiveScene3DEvent):void{
					
					p_runer.runScript(onRollOverMap[Plane(e.currentTarget)]);
				
				});
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT,function(e:InteractiveScene3DEvent):void{
					
					p_runer.runScript(onRollOutMap[Plane(e.currentTarget)]);
				
				});
			
			}
			
			viewer.draw();
		
		}
		private function resizeHandler(e:Event):void{
			
			TweenLite.delayedCall(0.1,viewer.draw);
			
		}
	}
}
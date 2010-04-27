package plugins.yzhkof.pv3d.control
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	import core.manager.popupManager.CustomPopupManager;
	import core.manager.popupManager.PopupManagerEvent;
	import core.manager.sceneManager.SceneManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.StageQuality;
	import flash.events.Event;
	
	import memory.MyGC;
	
	import mx.core.UIComponent;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.objects.primitives.Plane;
	
	import plugins.yzhkof.pv3d.view.Pv3d360Scene;
	import plugins.yzhkof.pv3d.view.Pv3d360SceneCompass;
	
	import view.AddToStageSetter;
	import view.pv3d.CameraRotationControler;
	import view.pv3d.event.CamereaControlerEvent;
	
	public class Pv3dSceneCtr extends UIComponent
	{
		private var pv3d:Pv3d360SceneCompass=new Pv3d360SceneCompass();
		private var currentSceneXml:XML;
		private var controler:CameraRotationControler;
		private var updata_type:String;//全景材质的类型
		private var controlerCompleteScript:String="";
		public function Pv3dSceneCtr()
		{
			initScript();
			initListener();
		}
		private function initScript():void
		{
			ScriptManager.getInstance().addApi(ScriptName.DISABLE_360_SYSTEM,disable360System);//删除全景
			ScriptManager.getInstance().addApi(ScriptName.ENABLE_360_SYSTEM,enable360System);  //enable全景
			ScriptManager.getInstance().addApi(ScriptName.GET_CAMERA,get360Camera);           //获取全景镜头
			ScriptManager.getInstance().addApi(ScriptName.GOTO_3D_SCENE,gotoScene);              //跳场景
			ScriptManager.getInstance().addApi(ScriptName.START_RENDER,startRender);          //开始渲染
			ScriptManager.getInstance().addApi(ScriptName.STOP_RENDER,stopRender);            //停止渲染
			ScriptManager.getInstance().addApi(ScriptName.SET_CAMERA,setCamera);              //设置镜头的相关参数
			ScriptManager.getInstance().addApi(ScriptName.SET_CAMERA_ROTATION_X,setCameraRotationX);
			ScriptManager.getInstance().addApi(ScriptName.SET_CAMERA_ROTATION_Y,setCameraRotationY);
			ScriptManager.getInstance().addApi(ScriptName.SET_CAMERA_FOCUS,setCameraFocus);
			ScriptManager.getInstance().addApi(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,initControlerCompleteScript);
		}
		private function initListener():void
		{
			CustomPopupManager.getInstance().addEventListener(PopupManagerEvent.SHOW_POPUP,function(e:PopupManagerEvent):void//关闭标准窗的时候就开始渲染
			{
				pv3d.stopRend();
			});
			CustomPopupManager.getInstance().addEventListener(PopupManagerEvent.REMOVE_POPUP,function(e:PopupManagerEvent):void//关闭标准窗的时候就开始渲染
			{
				pv3d.startRend();
			});
		}
		private function initControlerCompleteScript(script:String):void
		{
			controlerCompleteScript+=script;
		}
		private function disable360System():void
		{
			if(pv3d.parent!=null)
			{
				pv3d.parent.removeChild(pv3d);
			}
			stopRender();
		}
		private function enable360System():void
		{
			if(pv3d.parent==null)
			{
				this.addChild(pv3d);
			}
			if(controler==null)
			{
				AddToStageSetter.delayExcuteAfterAddToStage(pv3d,function():void{
					controler=new CameraRotationControler(pv3d,get360Camera());
					controler.addEventListener(CamereaControlerEvent.UPDATA,onCameraUpdata);
					controler.addEventListener(CamereaControlerEvent.UPDATAED,onCameraUpdataed);
					ScriptManager.getInstance().addApi(ScriptName.SET_GOTO_ROTATION,controler.setGotoRotation);
				});
			}
			startRender();
		}
		private function get360Camera():FreeCamera3D
		{
			return pv3d.camera;
		}
		private function gotoScene(id:int):void
		{
			enable360System();
			currentSceneXml=ModelManager.getInstance().xmlPv3d.Scene[id];
			var onComplete:Function=function ():void{//全景图片加载完毕的时候调用
				updataArrows();
				updataHotPoints();
//				updateShpereAddon();
				SceneManager.getInstance().dispacherJustBeforeCompleteEvent(SceneManager.getInstance().currentSceneId);
				pv3d.disposeCacheBitMap();
				pv3d.draw();
				MyGC.gc();
			}
			var url:String=String(currentSceneXml.@materialPath);
			var type:String=String(currentSceneXml.@materialType);
			updata_type=type;
			pv3d.changeBitmap(url,type,onComplete);
		}
		private function updataArrows():void
		{
			var xml_compass:XMLList=currentSceneXml.Compass;
			pv3d.cleanAllArrow();
			for(var i:int=0;i<xml_compass.Arrow.length();i++){
				pv3d.addArrow(xml_compass.Arrow[i].@destination,xml_compass.Arrow[i].@rotation,xml_compass.Arrow[i].@tip);
			}
		}
		private function updataHotPoints():void
		{
			var xml_animate:XMLList=currentSceneXml.Animate;
			var cache:Boolean;
			pv3d.cleanAllAnimate();
			for(var i:int=0;i<xml_animate.length();i++){
				cache=xml_animate[i].@cache==1?true:false;				
				pv3d.addAminate(xml_animate[i].@url,{x:xml_animate[i].@x,y:xml_animate[i].@y,z:xml_animate[i].@z,rotationX:xml_animate[i].@rotationX,rotationY:xml_animate[i].@rotationY,rotationZ:xml_animate[i].@rotationZ,width:xml_animate[i].@width,height:xml_animate[i].@height,segmentsW:xml_animate[i].@segmentsW,segmentsH:xml_animate[i].@segmentsH,offset:xml_animate[i].@offset,angle:xml_animate[i].@angle,force:xml_animate[i].@force,onClick:xml_animate[i].@onClick,visible:xml_animate[i].@visible,tip:xml_animate[i].@tip,scaleX:xml_animate[i].@scaleX,scaleY:xml_animate[i].@scaleY,movement:xml_animate[i].@movement,speed:xml_animate[i].@speed,maxHeight:xml_animate[i].@maxHeight,minHeight:xml_animate[i].@minHeight,filter:xml_animate[i].@filter,sign:xml_animate[i].@sign,debuge:xml_animate[i].@debuge,autoKeep:xml_animate[i].@autoKeep,onOver:xml_animate[i].@onOver,onOut:xml_animate[i].@onOut},cache);
			}
		}
		private function updateShpereAddon():Boolean
		{
			var xml_ShpereAddon:XMLList=currentSceneXml.ShpereAddon;
			if(xml_ShpereAddon.length()==0)
			{
				SceneManager.getInstance().dispacherJustBeforeCompleteEvent(SceneManager.getInstance().currentSceneId);
				return false;
			}
			pv3d.updateAddons(xml_ShpereAddon);
			return true;
		}
		private function startRender():void
		{
			pv3d.startRend();
		}
		private function stopRender():void
		{
			pv3d.stopRend();
		}
		private function onCameraUpdataed(e:Event):void{
			pv3d.stage.quality=StageQuality.HIGH;
			switch(updata_type){
				case "movieclip":
					pv3d.render_type=Pv3d360Scene.REND_ALL;
				break;
				default:
					pv3d.draw();
					pv3d.render_type=Pv3d360Scene.REND_ANIMATE;
				break;
			}	
			if(controlerCompleteScript!=null)
			{
				ScriptManager.getInstance().runScriptDirectly(controlerCompleteScript);
				controlerCompleteScript="";
			}	
		}
		private function onCameraUpdata(e:Event):void{
			pv3d.stage.quality=StageQuality.LOW;
			pv3d.render_type=Pv3d360Scene.REND_ALL;
		}
		private function setCamera(rotationX:Number,rotationY:Number):void
		{
			MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[rotationX-get360Camera().rotationX,rotationY-get360Camera().rotationY]);
		}
		private function setCameraRotationX(rotationX:Number):void
		{
			if(controler!=null)
			{
				controler.setRotation(rotationX-get360Camera().rotationX,get360Camera().rotationY);
			}else
			{
				get360Camera().rotationX=rotationX;
			}
		}
		private function setCameraRotationY(rotationY:Number):void
		{
			if(controler!=null)
			{
				controler.setRotation(get360Camera().rotationX,rotationY-get360Camera().rotationY);
			}else
			{
				get360Camera().rotationY=rotationY;
			}
		}
		private function setCameraFocus(focus:Number):void
		{
			get360Camera().focus=focus;
		}
	}
}
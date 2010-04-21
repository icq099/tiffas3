package plugins.yzhkof.pv3d.control
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	import core.manager.sceneManager.SceneManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.StageQuality;
	import flash.events.Event;
	
	import memory.MyGC;
	
	import mx.core.UIComponent;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
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
			ScriptManager.getInstance().addApi(ScriptName.DISABLE360SYSTEM,disable360System);//删除全景
			ScriptManager.getInstance().addApi(ScriptName.ENABLE360SYSTEM,enable360System);  //enable全景
			ScriptManager.getInstance().addApi(ScriptName.GETCAMERA,get360Camera);           //获取全景镜头
			ScriptManager.getInstance().addApi(ScriptName.GOTO3DSCENE,gotoScene);              //跳场景
			ScriptManager.getInstance().addApi(ScriptName.STARTRENDER,startRender);          //开始渲染
			ScriptManager.getInstance().addApi(ScriptName.STOPRENDER,stopRender);            //停止渲染
			ScriptManager.getInstance().addApi(ScriptName.SETCAMERA,setCamera);              //设置镜头的相关参数
			ScriptManager.getInstance().addApi(ScriptName.SETCAMERAROTATIONX,setCameraRotationX);
			ScriptManager.getInstance().addApi(ScriptName.SETCAMERAROTATIONY,setCameraRotationY);
			ScriptManager.getInstance().addApi(ScriptName.SETCAMERAFOCUS,setCameraFocus);
			ScriptManager.getInstance().addApi(ScriptName.ADDCONTROLERCOMPLETESCRIPT,initControlerCompleteScript);
		}
		private function initControlerCompleteScript(script:String):void
		{
			script=ScriptManager.getInstance().filterScript(script);
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
					ScriptManager.getInstance().addApi(ScriptName.SETGOTOROTATION,controler.setGotoRotation);
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
			currentSceneXml=ModelManager.getInstance().xmlBasic.Travel.Scene[id];
			var onComplete:Function=function ():void{//全景图片加载完毕的时候调用
				updataArrows(id);
				updataHotPoints(id);
				updateShpereAddon();
				pv3d.draw();
				MyGC.gc();
			}
			var url:String=String(currentSceneXml.@materialPath);
			var type:String=String(currentSceneXml.@materialType);
			updata_type=type;
			pv3d.changeBitmap(url,type,onComplete);
		}
		private function updataArrows(id:int):void
		{
			var xml_compass:XMLList=currentSceneXml.Compass;
			pv3d.cleanAllArrow();
			for(var i:int=0;i<xml_compass.Arrow.length();i++){
				var arrow:Plane=pv3d.addArrow(xml_compass.Arrow[i].@rotation,xml_compass.Arrow[i].@tip);
				var destination:int=xml_compass.Arrow[i].@destination;
				arrow.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE,function(e:InteractiveScene3DEvent):void{
					SceneManager.getInstance().gotoScene(destination);
				})
			}
		}
		private function updataHotPoints(id:int):void
		{
			var xml_animate:XMLList=currentSceneXml.Animate;
			var cache:Boolean;
			pv3d.cleanAllAnimate();
			for(var i:int=0;i<xml_animate.length();i++){
				cache=xml_animate[i].@cache==1?true:false;				
				var plane:Plane=pv3d.addAminate(xml_animate[i].@url,{x:xml_animate[i].@x,y:xml_animate[i].@y,z:xml_animate[i].@z,rotationX:xml_animate[i].@rotationX,rotationY:xml_animate[i].@rotationY,rotationZ:xml_animate[i].@rotationZ,width:xml_animate[i].@width,height:xml_animate[i].@height,segmentsW:xml_animate[i].@segmentsW,segmentsH:xml_animate[i].@segmentsH,offset:xml_animate[i].@offset,angle:xml_animate[i].@angle,force:xml_animate[i].@force,onClick:xml_animate[i].@onClick,visible:xml_animate[i].@visible,tip:xml_animate[i].@tip,scaleX:xml_animate[i].@scaleX,scaleY:xml_animate[i].@scaleY,movement:xml_animate[i].@movement,speed:xml_animate[i].@speed,maxHeight:xml_animate[i].@maxHeight,minHeight:xml_animate[i].@minHeight,filter:xml_animate[i].@filter,sign:xml_animate[i].@sign,debuge:xml_animate[i].@debuge,autoKeep:xml_animate[i].@autoKeep},cache);
			}
		}
		private function updateShpereAddon():void
		{
			var xml_ShpereAddon:XMLList=currentSceneXml.ShpereAddon;
			pv3d.updateAddons(xml_ShpereAddon);
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
			MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SETGOTOROTATION,[rotationX-get360Camera().rotationX,rotationY-get360Camera().rotationY]);
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
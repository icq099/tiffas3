package plugins.yzhkof.pv3d
{
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import mx.core.UIComponent;
	
	import org.papervision3d.cameras.FreeCamera3D;
	
	public class Pv3dModuleBase extends UIComponent
	{
		private var pv3d:Pv3d360SceneCompass=new Pv3d360SceneCompass();
		public function Pv3dModuleBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.DISABLE360SYSTEM,disable360System);//删除全景
			ScriptManager.getInstance().addApi(ScriptName.ENABLE360SYSTEM,enable360System);  //enable全景
			ScriptManager.getInstance().addApi(ScriptName.GETCAMERA,get360Camera);           //获取全景镜头
			ScriptManager.getInstance().addApi(ScriptName.GOTOSCENE,gotoScene);              //跳场景
			ScriptManager.getInstance().addApi(ScriptName.STARTRENDER,startRender);          //开始渲染
			ScriptManager.getInstance().addApi(ScriptName.STOPRENDER,stopRender);            //停止渲染
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
			startRender();
		}
		private function get360Camera():FreeCamera3D
		{
			return pv3d.camera;
		}
		private function gotoScene(id:int):void
		{
			
		}
		private function startRender():void
		{
			pv3d.startRend();
		}
		private function stopRender():void
		{
			pv3d.stopRend();
		}
	}
}
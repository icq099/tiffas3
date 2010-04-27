package plugins.lsd.AnimatePlayer.control
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	import core.manager.pluginManager.PluginManager;
	import core.manager.popupManager.CustomPopupManager;
	import core.manager.popupManager.PopupManagerEvent;
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.sceneManager.SceneManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import memory.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	import plugins.lsd.AnimatePlayer.view.AnimatePlayer;
	
	public class AnimatePlayerCtr extends UIComponent
	{
		private var animatePlayer:AnimatePlayer
		private var ID:int;
		public function AnimatePlayerCtr()
		{
			ScriptManager.getInstance().addApi(ScriptName.ADD_ANIMATE,init);
			ScriptManager.getInstance().addApi(ScriptName.REMOVE_ANIMATE,dispose);
		}
		private function init(id:int,controlRender:Boolean=false):void
		{
			if(animatePlayer==null)//保持精灵唯一
			{
				this.parent.x=0;
				this.parent.y=0;
				animatePlayer=new AnimatePlayer();
				if(id!=-1)//-1就不显示桂娃了
				{
					this.ID=id;
					this.addChild(animatePlayer);
					animatePlayer.load(ModelManager.getInstance().xmlAnimate.Animate[ID].@url);
					SceneManager.getInstance().addEventListener(SceneChangeEvent.INIT,on_init);
					CustomPopupManager.getInstance().addEventListener(PopupManagerEvent.SHOW_POPUP,onNormalWindowShow);//弹标准窗的时候也要删掉自己
				}
			}
		}
		private function onNormalWindowShow(e:PopupManagerEvent):void
		{
			MemoryRecovery.getInstance().gcFun(CustomPopupManager.getInstance(),PopupManagerEvent.SHOW_POPUP,onNormalWindowShow);
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVE_ANIMATE,[]);
		}
		private function on_init(e:SceneChangeEvent):void
		{
			PluginManager.getInstance().removeEventListener(SceneChangeEvent.INIT,on_init);
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVE_ANIMATE,[]);
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(CustomPopupManager.getInstance(),PopupManagerEvent.SHOW_POPUP,onNormalWindowShow);
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.INIT,on_init);
			if(animatePlayer!=null)
			{
				if(animatePlayer.parent!=null)
				{
					animatePlayer.parent.removeChild(animatePlayer);
				}
				animatePlayer.dispose();
				animatePlayer=null;
			}
		}
	}
}
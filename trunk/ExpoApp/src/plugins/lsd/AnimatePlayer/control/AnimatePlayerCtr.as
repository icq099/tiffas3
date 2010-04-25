package plugins.lsd.AnimatePlayer.control
{
	import core.manager.modelManager.ModelManager;
	import core.manager.pluginManager.PluginManager;
	import core.manager.sceneManager.SceneManager;
	import core.manager.sceneManager.SceneChangeEvent;
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
		private function init(id:int,controlRender:Boolean=false):AnimatePlayer
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
			}
			return null;
		}
		private function on_init(e:SceneChangeEvent):void
		{
			PluginManager.getInstance().removeEventListener(SceneChangeEvent.INIT,on_init);
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVE_ANIMATE,[]);
		}
		public function dispose():void
		{
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
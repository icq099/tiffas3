package plugins.lsd.AnimatePlayer.control
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	import core.manager.pluginManager.PluginManager;
	import core.manager.pluginManager.event.PluginEvent;
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
			ScriptManager.getInstance().addApi(ScriptName.ADDANIMATE,init);
			ScriptManager.getInstance().addApi(ScriptName.REMOVEANIMATE,dispose);
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
				PluginManager.getInstance().addEventListener(PluginEvent.UPDATE,on_update);
			}
			return null;
		}
		private function on_update(e:PluginEvent):void
		{
			PluginManager.getInstance().removeEventListener(PluginEvent.UPDATE,on_update);
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVEANIMATE,[]);
		}
		public function dispose():void
		{
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
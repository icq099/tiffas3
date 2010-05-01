package plugins.lxfa.animatePlayer
{
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.sceneManager.SceneManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import memory.MemoryRecovery;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	import plugins.lxfa.animatePlayer.model.AnimatePlayerModel;
	
	import view.player.SwfPlayer;
	
	public class AnimatePlayer extends EventDispatcher
	{
		private static var _instance:AnimatePlayer;
		private var animate:SwfPlayer;
		public function AnimatePlayer()
		{
			if(_instance==null)
			{
				_instance=this;
			}else
			{
				throw new Error("AnimatePlayer不能被实例化");
			}
		}
		public function init():void
		{
			ScriptManager.getInstance().addApi(ScriptName.REFRESH_ANIMATE_TEXT,refreshAnimateText);
			ScriptManager.getInstance().addApi(ScriptName.REMOVE_ANIMATE,removeAnimate);
			ScriptManager.getInstance().addApi(ScriptName.ADD_ANIMATE,showAnimate);
			ScriptManager.getInstance().addApi(ScriptName.SHOW_ANIMATE_OUT,showOut);
			if(animate==null)
			{
				animate=new SwfPlayer("swf/animate/animate.swf",900,480);
				animate.addEventListener(Event.COMPLETE,function(e:Event):void
				{
					dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.ALL_STOP));
					dispatchEvent(e);
				});
			}
		}
		/**
		 * 刷新精灵的文本
		 */ 
		public function refreshAnimateText(text:String):void
		{
			this.dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.REFRESH_TEXT,text));
		}
		/**
		 * 显示进场的动画,要是中途没有被关闭，进场完毕就自动显示说话的动画;要是被关闭就不显示说话动画了
		 */ 
		private function showIn():void
		{
			this.dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.SHOW_ANIMATE_IN));
		}
		/**
		 * 显示说话的动画,只要没遇到show_out事件或all_stop，那么就一直说话
		 */ 
		private function showSay():void
		{
			this.dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.SHOW_ANIMATE_SAY));
		}
		/**
		 * 显示退出的动画，退出完毕会自动关闭退出动画
		 */ 
		private function showOut():void
		{
			this.dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.SHOW_ANIMATE_OUT));
		}
		/**
		 * 刷新文本
		 */ 
		private function refreshText(text:String):void
		{
			this.dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.REFRESH_TEXT,text));
		}
		public static function getInstance():AnimatePlayer
		{
			if(_instance==null) return new AnimatePlayer();
			return _instance;
		}
		/**
		 * 根据ID显示指定的桂娃
		 */ 
		public function showAnimate(id:int):void
		{
			if(id!=-1)
			{
				removeAnimate();
				PopUpManager.addPopUp(animate,DisplayObject(Application.application),false);
				PopUpManager.centerPopUp(animate);
				animate.y=270;
				animate.x=500;
				AnimatePlayerModel.getInstance().init(id);
				dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.REFRESH_TEXT_STATE,"",AnimatePlayerModel.getInstance().hasText));//决定是否显示文本
				AnimateMusicManager.getInstance().loadBackGroundMusic(AnimatePlayerModel.getInstance().musicUrl);//加载音乐
				AnimateMusicManager.getInstance().addEventListener(Event.COMPLETE,downLoaded);
				//自动删除自己
				SceneManager.getInstance().addEventListener(SceneChangeEvent.INIT,on_init);
			}
		}
		/**
		 * 音乐加载完毕
		 */ 
		private var delayKey:int;
		private function downLoaded(e:Event):void
		{
			delayKey=setInterval(delayShow,500);
		}
		private function delayShow():void
		{
			clearInterval(delayKey);
			AnimateMusicManager.getInstance().removeEventListener(Event.COMPLETE,downLoaded);
			AnimateMusicManager.getInstance().play();
			this.showIn();
			Application.application.addEventListener(Event.ENTER_FRAME,on_enter_frame);
		}
		/**
		 * 更新文字
		 */ 
		private function on_enter_frame(e:Event):void
		{
			if(AnimatePlayerModel.getInstance().textsLength>0)
			{
				if(AnimateMusicManager.getInstance().getPosition()>AnimatePlayerModel.getInstance().getNearestTime())//如果当前播放的时间超过最近要显示文字的时间
				{
					var task:Object=AnimatePlayerModel.getInstance().getNearestTask();
					ScriptManager.getInstance().runScriptDirectly(task.script);
				}
			}else//没可以显示的文字了
			{
				Application.application.removeEventListener(Event.ENTER_FRAME,on_enter_frame);
			}
		}
		/**
		 * 清除桂娃
		 */ 
		public function removeAnimate():void
		{
			this.dispatchEvent(new AnimatePlayerEvent(AnimatePlayerEvent.ALL_STOP));
			clearInterval(delayKey);
			MemoryRecovery.getInstance().gcFun(AnimateMusicManager.getInstance(),Event.COMPLETE,downLoaded);
			MemoryRecovery.getInstance().gcFun(Application.application,Event.ENTER_FRAME,on_enter_frame);
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.INIT,on_init);
			AnimateMusicManager.getInstance().dispose();
			AnimatePlayerModel.getInstance().dispose();
			if(animate.parent!=null)
			{
				PopUpManager.removePopUp(animate);
			}
		}
		/**
		 * 实现自动删除
		 */ 
		private function on_init(e:SceneChangeEvent):void
		{
			SceneManager.getInstance().removeEventListener(SceneChangeEvent.INIT,on_init);
			removeAnimate();
		}
	}
}
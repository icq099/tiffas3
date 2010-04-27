package plugins.lxfa.flvModule
{
	import caurina.transitions.Tweener;
	
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.sceneManager.SceneManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import util.view.player.FLVPlayer;
	import util.view.player.event.FLVPlayerEvent;
	
	import view.loadings.LoadingWaveRota;
	
	public class FlvBase extends UIComponent
	{
		private var flvPlayer:FLVPlayer;
		private var onPlayCompleteScript:String;
		private var loading_mc:LoadingWaveRota;
		public function FlvBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.SHOW_FLV,initPlayer);
			ScriptManager.getInstance().addApi(ScriptName.REMOVE_FLV,dispose);
			ScriptManager.getInstance().addApi(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,initOnPlayCompleteScript);
		}
		public function initPlayer(url:String,hasCloseButton:Boolean=false):void
		{
			flvPlayer=new FLVPlayer(url,900,480,hasCloseButton);
			this.addChild(flvPlayer);
			loading_mc=new LoadingWaveRota();
			loading_mc.x=Application.application.width/2;
			loading_mc.y=Application.application.height/2;
			Application.application.addChildAt(loading_mc,Application.application.numChildren-1);
			flvPlayer.y=70;
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_play_complete);
			flvPlayer.addEventListener(Event.CLOSE,onClose);
			flvPlayer.addEventListener(ProgressEvent.PROGRESS,PROGRESS_refresh);
			flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE,on_complete);
			SceneManager.getInstance().addEventListener(SceneChangeEvent.COMPLETE,dispose);
		}
		private function on_complete(e:FLVPlayerEvent):void
		{
			if(loading_mc!=null)
			{
				if(loading_mc.parent!=null)
				{
					loading_mc.parent.removeChild(loading_mc);
				}
			}
			loading_mc=null;
			flvPlayer.resume();
		}
		private function PROGRESS_refresh(e:ProgressEvent):void
		{
			loading_mc.updateByProgressEvent(e);
		}
		private function on_play_complete(e:NetStatusEvent):void
		{
			ScriptManager.getInstance().runScriptDirectly(onPlayCompleteScript);
		}
		private function onClose(e:Event):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
			flvPlayer.removeEventListener(Event.CLOSE,onClose);
			flvPlayer.removeEventListener(NetStatusEvent.NET_STATUS,on_play_complete);
		}
		//存储播放完毕时要调用的脚本
		private function initOnPlayCompleteScript(onPlayCompleteScript:String):void
		{
			this.onPlayCompleteScript=onPlayCompleteScript;
		}
		public function dispose(e:SceneChangeEvent):void
		{
			if(flvPlayer!=null)
			{
				Tweener.addTween(flvPlayer,{alpha:0,time:3,onComplete:function():void{
					flvPlayer.pause();
					flvPlayer.parent.removeChild(flvPlayer);
					flvPlayer.dispose();
					flvPlayer=null;
				}});
			}
		}
	}
}
package plugins.lxfa.yangmengbagui.view
{
	import caurina.transitions.Tweener;
	
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.pluginManager.event.PluginEvent;
	import core.manager.sceneManager.SceneManager;
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import memory.MemoryRecovery;
	import memory.MyGC;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import plugins.lxfa.mainMenuBottom.MainMenuStatic;
	import plugins.lxfa.normalWindow.event.NormalWindowEvent;
	
	import util.view.player.FLVPlayer;
	import util.view.player.event.FLVPlayerEvent;
	
	import view.fl2mx.Fl2Mx;
	import view.loadings.LoadingWaveRota;
	import view.player.SwfPlayer;
	
	public class YangMengBaGuiBase extends UIComponent
	{
		private var yangMengBaGuiSwc:YangMengBaGuiSwc;
		private var LED:FLVPlayer;
		private var view3d:MiniCarouselReflectionView=new MiniCarouselReflectionView();
		private var flvPlayer:FLVPlayer;
		public function YangMengBaGuiBase(withMovie:Boolean=false)
		{
			MainMenuStatic.currentSceneId=6;
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));//抛出插件刷新事件
			MainSystem.getInstance().dispatchEvent(new SceneChangeEvent(SceneChangeEvent.INIT,6));
			ScriptManager.getInstance().runScriptByName(ScriptName.STOP_RENDER,[]);
			showYangMengBaGui(withMovie);
			MainSystem.getInstance().isBusy=true;
		}
		public function showYangMengBaGui(withMovie:Boolean):void
		{
			if(withMovie)
			{
				initPlayer();
			}else
			{
				initSwf();
			}
		}
		//过场动画
		private function initPlayer():void
		{
			flvPlayer=new FLVPlayer("http://flv.pavilion.expo.cn/p5006/flv/scene_scene/zonghengsihai_yangmengbagui.flv",900,480,false);
	        flvPlayer.y=70;
			flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE,on_download_complete);
		}
		private function on_download_complete(e:FLVPlayerEvent):void
		{
			if(flvPlayer!=null)
			{
				flvPlayer.resume();
				Application.application.addChild(Fl2Mx.fl2Mx(flvPlayer));
				flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_net_state_change);
			}
		}
		//背景SWF
		private var flowerFlvSwf:SwfPlayer;
		private var loading_mc:LoadingWaveRota;//用于显示进度
		public function initSwf():void
		{
			initLoadingMc();
			flowerFlvSwf=new SwfPlayer("swf/yangmengbagui.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
			flowerFlvSwf.addEventListener(ProgressEvent.PROGRESS,on_progress);
			flowerFlvSwf.y=70;
		}
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			loading_mc.x=900/2;
			loading_mc.y=600/2;
			Application.application.addChild(loading_mc);//添加到Application，这样才可以覆盖插件
		}
		private function on_progress(e:ProgressEvent):void
		{
			loading_mc.updateByProgressEvent(e);//更新显示的进度
		}
		private function onComplete(e:Event):void
		{
			if(loading_mc!=null)
			{
				if(loading_mc.parent!=null)
				{
					loading_mc.parent.removeChild(loading_mc);
				}
				loading_mc=null;
			}
			this.addChild(flowerFlvSwf);
			initLED();
			if(view3d!=null)
			{
				this.addChild(view3d);
			}
			Tweener.addTween(flvPlayer,{alpha:0,time:3,onComplete:function():void{
				if(flvPlayer!=null)
				{
					if(flvPlayer.parent!=null)
					{
						flvPlayer.parent.removeChild(flvPlayer);
					}
					flvPlayer.dispose();
					flvPlayer=null;
				}
			}});
			initYangMengBaGuiSwc();
			MainSystem.getInstance().isBusy=false;
			SceneManager.getInstance().dispatchEvent(new SceneChangeEvent(SceneChangeEvent.COMPLETE,6));
			SceneManager.getInstance().addEventListener(SceneChangeEvent.COMPLETE,close,false,0,true);
			SceneManager.getInstance().addEventListener(SceneChangeEvent.INIT,on_other_scene_init,false,0,true);
		}
		private function on_other_scene_init(e:SceneChangeEvent):void
		{
			LED.dispose();
			flowerFlvSwf.enabled=false;
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.INIT,on_other_scene_init);
		}
		private function on_net_state_change(e:NetStatusEvent):void
		{
			initSwf();
			MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS,on_net_state_change);
		}
		//添加杨梦八桂的建筑
		private function initYangMengBaGuiSwc():void
		{
			yangMengBaGuiSwc=new YangMengBaGuiSwc();
			yangMengBaGuiSwc.x=461;
			yangMengBaGuiSwc.y=115;
			yangMengBaGuiSwc.yangmengbagui.mouseEnabled=false;
			yangMengBaGuiSwc.mouseEnabled=false;
			this.addChild(yangMengBaGuiSwc);
		}
		//添加LED墙
		private function initLED():void
		{
			LED=new FLVPlayer("http://flv.pavilion.expo.cn/p5006/flv/yangmengbagui/yangmengbagui.flv",130,56,false);
			this.addChild(LED);
			LED.x=109;
			LED.y=403;
			LED.scaleX=0.145;
			LED.scaleY=0.12;
			LED.rotation=-1.5;
			LED.buttonMode=true;
			LED.addEventListener(MouseEvent.CLICK,on_LED_Click);
			LED.resume();
			LED.addEventListener(NetStatusEvent.NET_STATUS,on_LED_play_complete);
			MainSystem.getInstance().addEventListener(NormalWindowEvent.SHOW,on_normalwindow_show);
			MainSystem.getInstance().addEventListener(NormalWindowEvent.REMOVE,on_normalwindow_remove);
		}
		private function on_normalwindow_show(e:NormalWindowEvent):void
		{
			if(view3d!=null)
			{
				view3d.stopRender();
			}
			LED.pause();//暂停LED播放
		}
		private function on_normalwindow_remove(e:NormalWindowEvent):void
		{
			if(view3d!=null)
			{
				view3d.startRender();
			}
			LED.resume();
			LED.mouseEnabled=true;
		}
		//播放完毕就重播
		private function on_LED_play_complete(e:NetStatusEvent):void
		{
			LED.restart();
		}
		//LED点击事件
		private function on_LED_Click(e:MouseEvent):void
		{
			LED.pause();//暂停LED播放
			LED.mouseEnabled=false;
			//显示标准窗
			MainSystem.getInstance().runAPIDirectDirectly("showNormalWindow",[51]);
		}
		private function close(e:SceneChangeEvent):void
		{
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.COMPLETE,close);
			Tweener.addTween(this,{alpha:0,time:1.5,onComplete:function():void{
			    PluginManager.getInstance().removePluginById("YangMengBaGuiModule");
			}});
		}
		//清除内存
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(flvPlayer,FLVPlayerEvent.COMPLETE,on_download_complete);
			MemoryRecovery.getInstance().gcFun(flowerFlvSwf,Event.COMPLETE,onComplete);
			MemoryRecovery.getInstance().gcFun(flowerFlvSwf,ProgressEvent.PROGRESS,on_progress);
			MemoryRecovery.getInstance().gcFun(LED,MouseEvent.CLICK,on_LED_Click);
			MemoryRecovery.getInstance().gcFun(LED,NetStatusEvent.NET_STATUS,on_LED_play_complete);
			MemoryRecovery.getInstance().gcFun(MainSystem.getInstance(),NormalWindowEvent.SHOW,on_normalwindow_show);
			MemoryRecovery.getInstance().gcFun(MainSystem.getInstance(),NormalWindowEvent.REMOVE,on_normalwindow_remove);
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.INIT,on_other_scene_init);
			MemoryRecovery.getInstance().gcFun(SceneManager.getInstance(),SceneChangeEvent.COMPLETE,close);
			if(flvPlayer!=null)
			{
				if(flvPlayer.parent!=null)
				{
					flvPlayer.parent.removeChild(flvPlayer);
				}
				flvPlayer.dispose();
				flvPlayer=null;
			}
			if(flowerFlvSwf!=null)
			{
				if(flowerFlvSwf.parent!=null)
				{
					flowerFlvSwf.parent.removeChild(flowerFlvSwf);
				}
				flowerFlvSwf.dispose();
				flowerFlvSwf=null;
			}
			if(yangMengBaGuiSwc!=null)
			{
				if(yangMengBaGuiSwc.parent!=null)
				{
					yangMengBaGuiSwc.parent.removeChild(yangMengBaGuiSwc);
				}
				yangMengBaGuiSwc=null;
			}
			if(LED!=null)
			{
				if(LED.parent!=null)
				{
					LED.parent.removeChild(LED);
				}
				LED.dispose();
				LED=null;
			}
			if(view3d!=null)
			{
				if(view3d.parent!=null)
				{
					view3d.parent.removeChild(view3d);
				}
				view3d.dispose()
				view3d=null;
			}
			ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
			MyGC.gc();
		}
	}
}
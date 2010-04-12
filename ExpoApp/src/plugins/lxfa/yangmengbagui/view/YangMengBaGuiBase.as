package plugins.lxfa.yangmengbagui.view
{
	import caurina.transitions.Tweener;
	
	import core.manager.MainSystem;
	import core.manager.pluginManager.event.PluginEvent;
	import core.manager.sceneManager.event.SceneChangeEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import memory.MemoryRecovery;
	
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
//			MainSystem.getInstance().stopRender();
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
			MemoryRecovery.getInstance().gcObj(loading_mc);//下载完毕的时候回收LOADING_MC
			this.addChild(flowerFlvSwf);
			initLED();
			if(view3d!=null)
			{
				this.addChild(view3d);
			}
			Tweener.addTween(flvPlayer,{alpha:0,time:3,onComplete:function():void{
			   MemoryRecovery.getInstance().gcObj(flvPlayer,true);
			}});
			initYangMengBaGuiSwc();
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatchEvent(new SceneChangeEvent(SceneChangeEvent.COMPLETE,6));
			MainSystem.getInstance().addSceneChangeCompleteHandler(close,[]);
			MainSystem.getInstance().addSceneChangeInitHandler(function():void{
			    LED.dispose();
			    flowerFlvSwf.enabled=false;
//			    view3d.dispose();
			},[]);
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
			yangMengBaGuiSwc.addEventListener(MouseEvent.CLICK,on_yangMengBaGuiSwc_click);
			yangMengBaGuiSwc.buttonMode=true;
			this.addChild(yangMengBaGuiSwc);
		}
		private function on_yangMengBaGuiSwc_click(e:MouseEvent):void
		{
			MainSystem.getInstance().runAPIDirectDirectly("showNormalWindow",[45]);
		}
		//添加LED墙
		private function initLED():void
		{
			LED=new FLVPlayer("http://flv.pavilion.expo.cn/p5006/flv/yangmengbagui/yangmengbagui.flv",127,53,false);
			this.addChild(LED);
			LED.x=110;
			LED.y=404;
			LED.scaleX=0.143;
			LED.scaleY=0.114;
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
			LED.pause();//暂停LED播放
		}
		private function on_normalwindow_remove(e:NormalWindowEvent):void
		{
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
			MainSystem.getInstance().runAPIDirectDirectly("showNormalWindow",[44]);
		}
		private function close():void
		{
			Tweener.addTween(this,{alpha:0,time:1.5,onComplete:function():void{
			    MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["YangMengBaGuiModule"]);
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
			MemoryRecovery.getInstance().gcObj(flvPlayer,true);
			MemoryRecovery.getInstance().gcObj(flowerFlvSwf,true);
			MemoryRecovery.getInstance().gcObj(yangMengBaGuiSwc);
			MemoryRecovery.getInstance().gcObj(LED,true);
			MemoryRecovery.getInstance().gcObj(view3d,true);
		}
	}
}
package lxfa.yangmengbagui.view
{
	import caurina.transitions.Tweener;
	
	import communication.Event.PluginEvent;
	import communication.Event.ScriptAPIAddEvent;
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	
	import lxfa.customMusic.CustomMusicManager;
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.UIComponent;
	
	public class YangMengBaGuiBase extends UIComponent
	{
		private var yangMengBaGuiSwc:YangMengBaGuiSwc;
		private var LED:FLVPlayer;
		private var view3d:MiniCarouselReflectionView=new MiniCarouselReflectionView();
		private var flvPlayer:FLVPlayer;
		public function YangMengBaGuiBase()
		{
			MainSystem.getInstance().stopRender();
			showYangMengBaGui(false);
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
			flvPlayer=new FLVPlayer("movie/zonghengsihai-yangmengbagui.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.READY,on_flv_complete);
	        flvPlayer.resume();
	        flvPlayer.y=70;
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_complete);
		}
		private function on_flv_complete(e:FLVPlayerEvent):void
		{
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));//抛出插件刷新事件
			MainSystem.getInstance().addAutoClose(close,[]);
		}
		private function on_complete(e:Event):void
		{
			MainSystem.getInstance().isBusy=false;
			initSwf();
		}
		//背景SWF
		private var flowerFlvSwf:SwfPlayer;
		public function initSwf():void
		{
			flowerFlvSwf=new SwfPlayer("swf/yangmengbagui.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
			flowerFlvSwf.y=70;
		}
		private function onComplete(e:Event):void
		{
			this.addChild(flowerFlvSwf);
			if(view3d!=null)
			{
				this.addChild(view3d);
			}
			initYangMengBaGuiSwc();
			initLED();
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));//抛出插件刷新事件
			MainSystem.getInstance().addAutoClose(close,[]);
		}
		//添加杨梦八桂的建筑
		private function initYangMengBaGuiSwc():void
		{
			yangMengBaGuiSwc=new YangMengBaGuiSwc();
			yangMengBaGuiSwc.x=461;
			yangMengBaGuiSwc.y=115;
			yangMengBaGuiSwc.buttonMode=true;
			this.addChild(yangMengBaGuiSwc);
		}
		//添加LED墙
		private function initLED():void
		{
			LED=new FLVPlayer("video/yangmengbagui/yangmengbagui.flv",127,53,false);
			this.addChild(LED);
			LED.x=111;
			LED.y=405;
			LED.rotationZ=-2;
			LED.buttonMode=true;
			LED.addEventListener(MouseEvent.CLICK,on_LED_Click);
			LED.resume();
			LED.addEventListener(NetStatusEvent.NET_STATUS,on_LED_play_complete);
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
			MainSystem.getInstance().showPluginById("NormalWindowModule");
			MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.ADD_API,ADD_API);
		}
		private function ADD_API(e:ScriptAPIAddEvent):void
		{
			if(e.fun_name=="showNormalWindow")
			{
				var s:DisplayObject=MainSystem.getInstance().getPlugin("NormalWindowModule");
				MainSystem.getInstance().getPlugin("NormalWindowModule").addEventListener(Event.CLOSE,on_normalwindow_close);
				MainSystem.getInstance().runAPIDirect("showNormalWindow",[0]);
			}
		}
		private function on_normalwindow_close(e:Event):void//标准窗关闭的时候
		{
			LED.resume();
			LED.mouseEnabled=true;
		}
		private function close():void
		{
			Tweener.addTween(this,{alpha:0,time:1.5,onComplete:dispose});
		}
		//清除内存
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcObj(flvPlayer,true);
			MemoryRecovery.getInstance().gcObj(flowerFlvSwf,true);
			MemoryRecovery.getInstance().gcObj(yangMengBaGuiSwc);
			MemoryRecovery.getInstance().gcObj(LED,true);
			MemoryRecovery.getInstance().gcObj(view3d,true);
		}
	}
}
package lxfa.yangmengbagui.view
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;
	
	public class YangMengBaGuiBase extends UIComponent
	{
		private var flvPlayer:FLVPlayer;
		private var yangMengBaGuiSwc:YangMengBaGuiSwc;
		private var LED:FLVPlayer;
		private var view3d:MiniCarouselReflectionView=new MiniCarouselReflectionView();
		public function YangMengBaGuiBase()
		{
			MainSystem.getInstance().disable360System();
			MainSystem.getInstance().addAPI("showYangMengBaGui",showYangMengBaGui);
			MainSystem.getInstance().runAPIDirect("showYangMengBaGui",[false]);
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
			this.addChild(flvPlayer);
			flvPlayer.y=70;
			refreshBottomLocation();
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_play_complete);
		}
		private function on_play_complete(e:NetStatusEvent):void
		{
			initSwf();
		}
		private function refreshBottomLocation():void
		{
			MainSystem.getInstance().runAPIDirect("updateBottomMenu",[]);
		}
		//背景SWF
		private var flowerFlvSwf:SwfPlayer;
		public function initSwf()
		{
			flowerFlvSwf=new SwfPlayer("swf/yangmengbagui.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
			flowerFlvSwf.y=70;
//			flowerFlvSwf.x=-200;
//			flowerFlvSwf.y=-100;
		}
		private function onComplete(e:Event):void
		{
			this.addChild(flowerFlvSwf);
			this.addChild(view3d);
			initYangMengBaGuiSwc();
			initLED();
			refreshBottomLocation();
			if(flvPlayer!=null)
			{
				MainSystem.getInstance().removePluginById("ZongHengSiHaiModule");
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			}
		}
		//添加杨梦八桂的建筑
		private function initYangMengBaGuiSwc():void
		{
			yangMengBaGuiSwc=new YangMengBaGuiSwc();
			yangMengBaGuiSwc.x=460;
			yangMengBaGuiSwc.y=120;
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
			if(!this.hasEventListener(Event.DEACTIVATE))//失去焦点
			{
				this.addEventListener(Event.MOUSE_LEAVE,on_this_deactive);
			}
			if(!this.hasEventListener(Event.ACTIVATE))//获得焦点
			{
//				this.addEventListener(Event.,on_this_active);
			}
		}
		private function on_this_deactive(e:Event):void
		{
			LED.pause();
			trace("失去焦点");
		}
		private function on_this_active(e:Event):void
		{
			LED.resume();
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
			//显示标准窗
			MainSystem.getInstance().showPluginById("NormalWindowModule");
			MainSystem.getInstance().runAPIDirect("showNormalWindow",[0]);
			MainSystem.getInstance().getPlugin("NormalWindowModule").addEventListener(Event.CLOSE,on_click);
		}
		private function on_click(e:Event):void//标准窗关闭的时候
		{
			LED.resume();
		}
	}
}
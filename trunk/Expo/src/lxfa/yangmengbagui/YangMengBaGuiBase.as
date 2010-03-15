package lxfa.yangmengbagui
{
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;
	
	public class YangMengBaGuiBase extends UIComponent
	{
		private var flvPlayer:FLVPlayer;
		public function YangMengBaGuiBase()
		{
			initPlayer();
		}
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
			if(flvPlayer!=null)
			{
				MainSystem.getInstance().removePluginById("ZongHengSiHaiModule");
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			}
			refreshBottomLocation();
		}
		private function refreshBottomLocation():void
		{
   			var dis:DisplayObject=MainSystem.getInstance().getPlugin("MainMenuBottomModule");
   			if(dis!=null)
   			{
	   			addChild(dis);
	   			dis.y=480;
	   			dis.x=1;
   			}
		}
		private var flowerFlvSwf:SwfPlayer;
		public function initSwf()
		{
			flowerFlvSwf=new SwfPlayer("movie/扬梦八桂.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
//			flowerFlvSwf.x=-200;
//			flowerFlvSwf.y=-100;
		}
		private function onComplete(e:Event):void
		{
			this.addChild(flowerFlvSwf);
			refreshBottomLocation();
		}
	}
}
package lxfa.No3.view
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.view.player.FLVPlayer;
	
	public class No3Base extends Sprite
	{
		private var flvPlayer:FLVPlayer;
		public function No3Base()
		{
			super();
			initFLVPlayer();
			initAnimation();
			initAPI();
		}
		private function initAnimation():void
		{
			MainSystem.getInstance().showPluginById("AnimationModule");
			MainSystem.getInstance().runAPIDirect("setAnimationLocation",[400,400]);
		}
		private function initFLVPlayer():void
		{
			flvPlayer=new FLVPlayer("video/no3/no3.flv",900,600);
			flvPlayer.addEventListener(Event.CLOSE,on_flvPlayer_close);
			this.addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,flvPlayer_NetStatus_handler);
		}
		private function flvPlayer_NetStatus_handler(e:Event):void
		{
			step4();
		}
		private function on_flvPlayer_close(e:Event):void
		{
			MainSystem.getInstance().runAPIDirect("gotoStep4",null);
		}
		private function initAPI():void
		{
			MainSystem.getInstance().addAPI("gotoStep4",step4);
		}
		private var swf:SwfPlayer;
		public function step4():void
		{
			MainSystem.getInstance().removePluginById("No3Module");
			swf=new SwfPlayer("movie/test.swf",900,480);
			swf.addEventListener(Event.COMPLETE,completeHandler);//SWF文件
			swf.addEventListener(MouseEvent.CLICK,onClick);
			MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
			MainSystem.getInstance().removePluginById("AnimationModule");
		}
		private function onClick(e:MouseEvent):void
		{
			trace("dsadsa");
		}
		private function completeHandler(e:Event):void
		{
			swf.x=-200;
			swf.y=-200;
			this.addChild(swf);
		}
		public function dispose():void
		{
			flvPlayer.dispose();
			flvPlayer=null;
		}
	}
}
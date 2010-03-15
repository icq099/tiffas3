package lxfa.zonghengsihaiWithMovie
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	
	import lxfa.view.player.FLVPlayer;
	
	public class ZongHengSiHaiWithMovieBase extends Sprite
	{
		private var flvPlayer:FLVPlayer;
		public function ZongHengSiHaiWithMovieBase()
		{
			initPlayer();
		}
		private function initPlayer():void
		{
			flvPlayer=new FLVPlayer("movie/铜鼓升起.flv",900,480,false);
			this.addChild(flvPlayer);
//			flvPlayer.x=100;
//			flvPlayer.y=100;
			refreshBottomLocation();
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_play_complete);
		}
		private function on_play_complete(e:NetStatusEvent):void
		{
			MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
			if(flvPlayer!=null)
			{
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			}
			refreshBottomLocation();
		}
		private function refreshBottomLocation():void
		{
			MainSystem.getInstance().runAPIDirect("updateBottomMenu",[]);
		}
		public function dispose():void
		{
			if(flvPlayer!=null)
			{
				flvPlayer.dispose();
				flvPlayer=null;
			}
		}
	}
}
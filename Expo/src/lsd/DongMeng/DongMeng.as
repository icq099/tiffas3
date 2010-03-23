package lsd.DongMeng
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	import yzhkof.loadings.LoadingWaveRota;
	import mx.core.Application;
	import flash.events.ProgressEvent;
	import yzhkof.Toolyzhkof;
	import flash.events.Event;
	import flash.events.NetStatusEvent;

	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;

	import mx.core.UIComponent;

	public class DongMeng extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
       	private var loading_mc:LoadingWaveRota;
		public function DongMeng()
		{
			MainSystem.getInstance().isBusy=true;
			initPlayer();
		}

		private function initPlayer():void
		{

			flvPlayer=new FLVPlayer("movie/gx-dm1.flv", 900, 480, false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.READY, on_flv_complete);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, on_Complete);
		}

		private function on_flv_complete(e:FLVPlayerEvent):void
		{
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			MainSystem.getInstance().addAutoClose(dispose_dm, []);
			MainSystem.getInstance().isBusy=true;
		}

		private function dispose_dm():void
		{

			if (MainSystem.getInstance().isBusy == true)
			{
				MainSystem.getInstance().isBusy == false
				dispose();
				MainSystem.getInstance().removePluginById("DongMengModule");
				removeAreas();
				MainSystem.getInstance().isBusy == true
			}
			else
			{

				MainSystem.getInstance().removePluginById("DongMengModule");
				removeAreas();
			}

		}

		private function on_Complete(e:NetStatusEvent):void
		{
			init();
		}

		private function flvRemove():void
		{
			MemoryRecovery.getInstance().gcFun(flvPlayer, NetStatusEvent.NET_STATUS, on_Complete);
			MemoryRecovery.getInstance().gcFun(flvPlayer, NetStatusEvent.NET_STATUS, gx_Complete);
			MemoryRecovery.getInstance().gcFun(flvPlayer, FLVPlayerEvent.READY, on_flv_complete);
			MemoryRecovery.getInstance().gcObj(flvPlayer, true);
		}

		private function guangXiClick():void
		{
			backGuangXi();
			removeAreas();
		}

		private function backGuangXi():void
		{
			MainSystem.getInstance().isBusy=true;
			flvPlayer=new FLVPlayer("movie/dm-gx1.flv", 900, 480, false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(FLVPlayerEvent.READY, on_fz_gx_complete);
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_Complete);
		}

		private function on_fz_gx_complete(e:Event):void //FLV已经加载到场景里面
		{

			MainSystem.getInstance().addAutoClose(flvRemove, []);
		}

		private function gx_Complete(e:NetStatusEvent):void
		{
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
		}

		private function dongMengWindowClick():void
		{
			trace("dongMeng");
		}

		private function init():void
		{
			swfPlayer=new SwfPlayer("swf/dongMeng.swf", 900, 480);
			initLoadingMc();
			swfPlayer.addEventListener(ProgressEvent.PROGRESS, on_flv_progress);
			swfPlayer.addEventListener(Event.COMPLETE, on_swf_complete);

		}
        private function addAreas():void{
        	
        	var guangXiArea:Array=[[[325, 103], [387, 128]]];
			var dongMengWindowArea:Array=[[[660, 110], [870, 148]]];
			CollisionManager.getInstance().addCollision(guangXiArea, guangXiClick, "dm_gx")
			CollisionManager.getInstance().addCollision(dongMengWindowArea, dongMengWindowClick, "dongMengWindow");
			CollisionManager.getInstance().showCollision();
        }
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			loading_mc.x=450;
			loading_mc.y=200;
			addChild(Toolyzhkof.mcToUI(loading_mc));
		}

		private function on_flv_progress(e:ProgressEvent):void //FLV加载完毕
		{
			loading_mc.updateByProgressEvent(e);
		}

		private function on_swf_complete(e:Event):void
		{
			MemoryRecovery.getInstance().gcFun(swfPlayer, ProgressEvent.PROGRESS, on_flv_progress);
			MemoryRecovery.getInstance().gcObj(loading_mc);
			this.addChild(swfPlayer);
			addAreas();
			flvRemove();
			MainSystem.getInstance().isBusy=false;
		}

		private function removeAreas():void
		{  
			CollisionManager.getInstance().removeCollision("dm_gx");
			CollisionManager.getInstance().removeCollision("dongMengWindow");
		}

		public function dispose():void
		{

			MemoryRecovery.getInstance().gcFun(swfPlayer, Event.COMPLETE, on_swf_complete);
			MemoryRecovery.getInstance().gcObj(swfPlayer, true);
			removeAreas();
		}
	}
}
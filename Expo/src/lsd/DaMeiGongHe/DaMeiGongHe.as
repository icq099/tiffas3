package lsd.DaMeiGongHe
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	import yzhkof.loadings.LoadingWaveRota;
	import mx.core.Application;
	import flash.events.ProgressEvent;
	import yzhkof.Toolyzhkof;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
    import mx.core.UIComponent;
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;

	public class DaMeiGongHe extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		private var loading_mc:LoadingWaveRota;

		public function DaMeiGongHe()
		{
			MainSystem.getInstance().isBusy=true;
			init();
		}

		private function dispose_dmg():void
		{
			if (MainSystem.getInstance().isBusy == true)
			{
				MainSystem.getInstance().isBusy == false
				dispose();
				MainSystem.getInstance().removePluginById("DaMeiGongHeModule");
				removeAreas();
				MainSystem.getInstance().isBusy == true
			}
			else
			{

				MainSystem.getInstance().removePluginById("DaMeiGongHeModule");
				removeAreas();
			}

		}

		private function flvRemove():void
		{
		
			MemoryRecovery.getInstance().gcFun(flvPlayer, NetStatusEvent.NET_STATUS, gx_Complete);
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
			flvPlayer=new FLVPlayer("movie/mgh-gx1.flv", 900, 480, false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_Complete);
		}

		private function gx_Complete(e:NetStatusEvent):void
		{

			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().addAutoClose(flvRemove, []);
			MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");

		}

		private function removeAreas():void
		{

			CollisionManager.getInstance().removeCollision("dmg_gx");
			CollisionManager.getInstance().removeCollision("daMeiGongHeWindow");
		}

		private function daMeiGongHeWindowClick():void
		{
			trace("dameigonghewindow");
		}

		private function init():void
		{

			swfPlayer=new SwfPlayer("swf/dameigonghe.swf", 900, 480);
			initLoadingMc();
			swfPlayer.addEventListener(ProgressEvent.PROGRESS, on_flv_progress);
			swfPlayer.addEventListener(Event.COMPLETE, on_swf_complete);
		}
       private function addAreas():void{
       	     
       	    var guangXiArea:Array=[[[485, 129], [610, 183]]];
			var daMeiGongHeWindowArea:Array=[[[670, 185], [880, 222]]];
			CollisionManager.getInstance().addCollision(guangXiArea, guangXiClick, "dmg_gx");
			CollisionManager.getInstance().addCollision(daMeiGongHeWindowArea, daMeiGongHeWindowClick, "daMeiGongHeWindow");
       	    CollisionManager.getInstance().showCollision();
       }
		private function on_swf_complete(e:Event):void
		{
			
			MemoryRecovery.getInstance().gcObj(loading_mc);
			this.removeEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
			this.addChild(swfPlayer);
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			MainSystem.getInstance().addAutoClose(dispose_dmg, []);
			MainSystem.getInstance().isBusy=true;
			addAreas();
			flvRemove();
			MainSystem.getInstance().isBusy=false;
		}

		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			this.addEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
		}
		private function on_added_to_stage(e:Event):void
		{
			loading_mc.x=this.stage.stageWidth/2;
			loading_mc.y=this.stage.stageHeight/2;
			Application.application.addChild(Toolyzhkof.mcToUI(loading_mc));
		}
        private function on_flv_progress(e:ProgressEvent):void //FLV加载完毕
		{
			loading_mc.updateByProgressEvent(e);
		}

		public function dispose():void
		{
            MemoryRecovery.getInstance().gcFun(swfPlayer, ProgressEvent.PROGRESS, on_flv_progress);
			MemoryRecovery.getInstance().gcFun(swfPlayer, Event.COMPLETE, on_swf_complete);
			MemoryRecovery.getInstance().gcObj(swfPlayer, true);
			flvRemove();
			removeAreas();
		}
	}

}

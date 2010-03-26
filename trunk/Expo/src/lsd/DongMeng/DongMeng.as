package lsd.DongMeng
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.mainMenuBottom.MainMenuStatic;
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;
	import yzhkof.loadings.LoadingWaveRota;

	public class DongMeng extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
       	private var loading_mc:LoadingWaveRota;
		public function DongMeng()
		{
			MainMenuStatic.currentSceneId=52;
			MainSystem.getInstance().dispatcherSceneChangeInit(52);
			MainSystem.getInstance().dispatcherPluginUpdate();
			MainSystem.getInstance().isBusy=true;
			init();
		}


		private function dispose_dm():void
		{
			MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["DongMengModule"]);
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
			flvPlayer=new FLVPlayer("movie/dm-gx1.flv", 900, 480, false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_Complete);
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

		private function on_swf_complete(e:Event):void
		{
			
			MemoryRecovery.getInstance().gcObj(loading_mc);
			this.removeEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatcherSceneChangeComplete(51);
			this.addChild(swfPlayer);
			addAreas();
			MainSystem.getInstance().addSceneChangeCompleteHandler(dispose_dm,[]);
			MainSystem.getInstance().addSceneChangeInitHandler(function():void{
				removeAreas();
			},[]);
		}
		private function removeAreas():void
		{  
			CollisionManager.getInstance().removeCollision("dm_gx");
			CollisionManager.getInstance().removeCollision("dongMengWindow");
		}

		public function dispose():void
		{

			MemoryRecovery.getInstance().gcFun(swfPlayer, Event.COMPLETE, on_swf_complete);
			MemoryRecovery.getInstance().gcFun(swfPlayer, ProgressEvent.PROGRESS, on_flv_progress);
			MemoryRecovery.getInstance().gcObj(swfPlayer, true);
			flvRemove();
			removeAreas();
		}
	}
}
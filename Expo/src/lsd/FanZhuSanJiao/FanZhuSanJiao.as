package lsd.FanZhuSanJiao
{
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.mainMenuBottom.MainMenuStatic;
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;

	public class FanZhuSanJiao extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		private var loading_mc:LoadingWaveRota;

		public function FanZhuSanJiao()
		{   
			MainMenuStatic.currentSceneId=51;
			MainSystem.getInstance().dispatcherSceneChangeInit(51);
			MainSystem.getInstance().dispatcherPluginUpdate();
			MainSystem.getInstance().isBusy=true;
		    init();
		}
		
		private function dispose_fz():void
		{
			MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["FanZhuSanJiaoModule"]);
		}

		private function flvRemove():void
		{

			MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS, gx_Complete);
			MemoryRecovery.getInstance().gcObj(flvPlayer, true);

		}

		private function guangXiClick():void
		{   
			removeAreas();
			backGuangXi();
		}

		private function backGuangXi():void
		{
			MainSystem.getInstance().isBusy=true;
			flvPlayer=new FLVPlayer("movie/fz-gx1.flv", 900, 480, false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_Complete);
		}

		private function gx_Complete(e:NetStatusEvent):void
		{ //flv播放完毕
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
		}
		
		private function init():void
		{
			swfPlayer=new SwfPlayer("swf/fanZhuSanJiao.swf", 980, 490);
			initLoadingMc();
			swfPlayer.addEventListener(ProgressEvent.PROGRESS, on_flv_progress);
			swfPlayer.addEventListener(Event.COMPLETE, on_swf_complete);
		}
        private function addAreas():void{
        	CollisionManager.getInstance().init(DisplayObject(Application.application));
        	var guangXiArea:Array=[[[272, 299], [394, 377]], [[297, 377], [347, 410]]];
			var fanZhuWindowArea:Array=[[[680, 153], [892, 192]]]
        	CollisionManager.getInstance().addCollision(guangXiArea, guangXiClick, "fz_gx");
			CollisionManager.getInstance().addCollision(fanZhuWindowArea, fanZhuWindowClick, "fanZhuWindow");
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
		private var hasDispatcherSceneChangeComplete:Boolean;
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
			MainSystem.getInstance().addSceneChangeCompleteHandler(dispose_fz,[]);
			MainSystem.getInstance().addSceneChangeInitHandler(function():void{
				removeAreas();
			},[]);
		}

		private function removeAreas():void
		{
			CollisionManager.getInstance().removeCollision("fz_gx");
			CollisionManager.getInstance().removeCollision("fanZhuWindow");
		}


		private function fanZhuWindowClick():void
		{
			MainSystem.getInstance().runAPIDirect("showNormalWindow",[42]);
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

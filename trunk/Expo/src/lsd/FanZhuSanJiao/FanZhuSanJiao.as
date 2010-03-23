package lsd.FanZhuSanJiao
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.UIComponent;

	public class FanZhuSanJiao extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;

		public function FanZhuSanJiao()
		{
//			MainSystem.getInstance().addEventListener(PluginEvent.UPDATE,on_plugin_update);//场景切换时，系统抛出的插件更新事件
			MainSystem.getInstance().isBusy=true;
			initPlayer();
            
		}

		/* private function on_plugin_update(e:PluginEvent):void
		   {
		   MainSystem.getInstance().removePluginById(ZongHengSiHaiStatic.getInstance().currentModuleName);
		   MainSystem.getInstance().removeEventListener(PluginEvent.UPDATE,on_plugin_update);
		 } */
		private function initPlayer():void
		{

			flvPlayer=new FLVPlayer("movie/gx-fz1.flv", 900, 480, false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.READY, on_flv_complete);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, on_Complete);
		}

		private function on_flv_complete(e:FLVPlayerEvent):void
		{
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			MainSystem.getInstance().addAutoClose(dispose_fz, []);
			MainSystem.getInstance().isBusy=true;
		}

		private function dispose_fz():void
		{
            if(MainSystem.getInstance().isBusy==true)
			{
				MainSystem.getInstance().isBusy==false
				dispose();
				MainSystem.getInstance().removePluginById("FanZhuSanJiaoModule");
				removeAreas();
				MainSystem.getInstance().isBusy==true
			}else{
				
				MainSystem.getInstance().removePluginById("FanZhuSanJiaoModule");
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
			flvPlayer=new FLVPlayer("movie/fz-gx1.flv", 900, 480, false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.READY, on_fz_gx_complete);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_Complete);
		}

		private function gx_Complete(e:NetStatusEvent):void
		{ //flv播放完毕
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
		}

		private function on_fz_gx_complete(e:Event):void //FLV已经加载到场景里面
		{
			
			MainSystem.getInstance().addAutoClose(flvRemove, []);
		}

		private function init():void
		{
			var guangXiArea:Array=[[[272, 299], [394, 377]], [[297, 377], [347, 410]]];
			var fanZhuWindowArea:Array=[[[680, 153], [892, 192]]]
			swfPlayer=new SwfPlayer("swf/fanZhuSanJiao.swf", 980, 490);
			CollisionManager.getInstance().addCollision(guangXiArea, guangXiClick, "fz_gx");
			CollisionManager.getInstance().addCollision(fanZhuWindowArea, fanZhuWindowClick, "fanZhuWindow");
			this.addChild(swfPlayer);
			swfPlayer.addEventListener(Event.COMPLETE, on_swf_complete);
			CollisionManager.getInstance().showCollision();

		}

		private function on_swf_complete(e:Event):void
		{
			flvRemove();
			MainSystem.getInstance().isBusy=false;
		}

		private function removeAreas():void
		{
             //CollisionManager.getInstance().removeAllCollision();
			CollisionManager.getInstance().removeCollision("fz_gx");
			CollisionManager.getInstance().removeCollision("fanZhuWindow");
		}


		private function fanZhuWindowClick():void
		{
			trace("fanzhuwindow");
		}

		public function dispose():void
		{

			MemoryRecovery.getInstance().gcFun(swfPlayer, Event.COMPLETE, on_swf_complete);
			MemoryRecovery.getInstance().gcObj(swfPlayer, true);
			removeAreas();
			
			
		}
	}
}

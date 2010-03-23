package lsd.DongMeng
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	import lxfa.utils.MemoryRecovery;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.UIComponent;
	public class DongMeng extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function DongMeng()
		{   
			MainSystem.getInstance().isBusy=true;
			initPlayer();
		}
		private function initPlayer():void{
		
			flvPlayer=new FLVPlayer("movie/gx-dm1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.READY,on_flv_complete);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
       }
       private function on_flv_complete(e:FLVPlayerEvent):void
       {
       	MainSystem.getInstance().isBusy=false;
       	MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
       	MainSystem.getInstance().addAutoClose(dispose_dm, []);
       	MainSystem.getInstance().isBusy=true;
       }
       private function dispose_dm():void{
       	   
       	    if(MainSystem.getInstance().isBusy==true)
			{
				MainSystem.getInstance().isBusy==false
				dispose();
				MainSystem.getInstance().removePluginById("DongMengModule");
				removeAreas();
				MainSystem.getInstance().isBusy==true
			}else{
				
				MainSystem.getInstance().removePluginById("DongMengModule");
				removeAreas();
			}
  
       }
       private function on_Complete(e:NetStatusEvent):void{
      	    init();
      }
       private function flvRemove():void
		{
			MemoryRecovery.getInstance().gcFun(flvPlayer, NetStatusEvent.NET_STATUS, on_Complete);
			MemoryRecovery.getInstance().gcFun(flvPlayer, NetStatusEvent.NET_STATUS, gx_Complete);
			MemoryRecovery.getInstance().gcFun(flvPlayer, FLVPlayerEvent.READY, on_flv_complete);
			MemoryRecovery.getInstance().gcObj(flvPlayer, true);
		}	

	  private function guangXiClick():void{
			backGuangXi();
		    removeAreas();
		}
	  private function backGuangXi():void{
			MainSystem.getInstance().isBusy=true;
			flvPlayer=new FLVPlayer("movie/dm-gx1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(FLVPlayerEvent.READY, on_fz_gx_complete);
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,gx_Complete);	
		}
		private function on_fz_gx_complete(e:Event):void //FLV已经加载到场景里面
		{
			
			MainSystem.getInstance().addAutoClose(flvRemove, []);
		}
	   private function gx_Complete(e:NetStatusEvent):void{
      	    MainSystem.getInstance().isBusy=false;
      	    MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
      }
	  private function dongMengWindowClick():void{
			trace("dongMeng");
		}
      private function init():void{
		 	
		 	 var guangXiArea:Array=[[[325,103],[387,128]]];
		 	 var dongMengWindowArea:Array=[[[660,110],[870,148]]];
		 	 swfPlayer=new SwfPlayer("swf/dongMeng.swf",900,480);
		 	 this.addChild(swfPlayer);
		 	 swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
		 	 CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"dm_gx")
		 	 CollisionManager.getInstance().addCollision(dongMengWindowArea,dongMengWindowClick,"dongMengWindow");
             CollisionManager.getInstance().showCollision();

		 }
		private function on_swf_complete(e:Event):void
		{
			flvRemove();
			MainSystem.getInstance().isBusy=false;
		}
		 
	  private function removeAreas():void{
			
			CollisionManager.getInstance().removeCollision("dm_gx");
			CollisionManager.getInstance().removeCollision("dongMengWindow");
		}
	     
	   public function dispose():void{
	           
	        MemoryRecovery.getInstance().gcFun(swfPlayer, Event.COMPLETE, on_swf_complete);
			MemoryRecovery.getInstance().gcObj(swfPlayer, true);
			removeAreas();	
	   }
    }
}
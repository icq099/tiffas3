package lsd.DongMeng
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
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
			initPlayer();
		}
		private function initPlayer():void{
			MainSystem.getInstance().isBusy=true;
			flvPlayer=new FLVPlayer("movie/gx-dm1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.READY,on_flv_ready);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
       }
       private function on_flv_ready(e:FLVPlayerEvent):void
       {
       	MainSystem.getInstance().isBusy=false;
       	MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
       	MainSystem.getInstance().isBusy=true;
       }
       private function on_Complete(e:NetStatusEvent):void{
      	    init();
      }
       private function flvRemove():void
		{
			if (flvPlayer!=null)
			{   
				if(flvPlayer.hasEventListener(NetStatusEvent.NET_STATUS))
				{
					flvPlayer.removeEventListener(NetStatusEvent.NET_STATUS,on_Complete);
					flvPlayer.removeEventListener(NetStatusEvent.NET_STATUS,gx_Complete);
				}
				if(flvPlayer.parent!=null){
                flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
                flvPlayer=null;
              }
		   }
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
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,gx_Complete);	
		}
	   private function gx_Complete(e:NetStatusEvent):void{
      	    MainSystem.getInstance().isBusy=false;
      	    MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
      	    MainSystem.getInstance().addAutoClose(dispose,[]);
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
             //CollisionManager.getInstance().showCollision();

		 }
		private function on_swf_complete(e:Event):void
		{
			MainSystem.getInstance().isBusy=false;
			flvRemove();
		}
		 
	  private function removeAreas():void{
			
			CollisionManager.getInstance().removeAllCollision();
		}
	     
	   public function dispose():void{
			if (flvPlayer!=null)
			{   
				if(flvPlayer.hasEventListener(NetStatusEvent.NET_STATUS))
				{
					flvPlayer.removeEventListener(NetStatusEvent.NET_STATUS,on_Complete);
					flvPlayer.removeEventListener(NetStatusEvent.NET_STATUS,gx_Complete);
				}
				if(flvPlayer.parent!=null){
                flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
                flvPlayer=null;
              }
		   }
	   	    if(swfPlayer!=null){
	   	    	if(swfPlayer.parent!=null){
	   	    		swfPlayer.parent.removeChild(swfPlayer);
			   	    swfPlayer.removeEventListener(Event.COMPLETE,on_swf_complete);
			   	    swfPlayer.dispose();
			   	    swfPlayer=null;
	   	    		
	   	    	}
	   	   }  	
	   }
    }
}
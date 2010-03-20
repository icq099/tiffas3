package lsd.DongMeng
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lsd.ZongHengSiHai.ZongHengSiHaiStatic;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;
	public class DongMeng extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function DongMeng()
		{   
			MainSystem.getInstance().addEventListener(PluginEvent.UPDATE,on_plugin_update);//场景切换时，系统抛出的插件更新事件
			initPlayer();
		}
		private function on_plugin_update(e:PluginEvent):void
		{
			MainSystem.getInstance().removePluginById(ZongHengSiHaiStatic.getInstance().currentModuleName);
			MainSystem.getInstance().removeEventListener(PluginEvent.UPDATE,on_plugin_update);
		}
		private function initPlayer():void{
			
			flvPlayer=new FLVPlayer("movie/gx-dm1.flv",900,480,false);
			flvPlayer.addEventListener(Event.COMPLETE,on_flv_complete);
			addChild(flvPlayer);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
       }
      private function on_flv_complete(e:Event):void
      {
      	  MainSystem.getInstance().removePluginById(ZongHengSiHaiStatic.getInstance().currentModuleName);
      	  if(flvPlayer!=null && flvPlayer.hasEventListener(Event.COMPLETE))
      	  {
      	  	flvPlayer.removeEventListener(Event.COMPLETE,on_flv_complete);
      	  }
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
			flvPlayer=new FLVPlayer("movie/dm-gx1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,gx_Complete);	
		}
	   private function gx_Complete(e:NetStatusEvent):void{
      	    
      	    MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
      	    MainSystem.getInstance().addEventListener("zonghengsihai.complete",zongHengSiHai_fun);
      
      }
       private function zongHengSiHai_fun(e:Event):void{
       	
      	  MainSystem.getInstance().removePluginById("DongMengModule");   
	      flvRemove(); 
      	
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
			flvRemove();
		}
		 
	  private function removeAreas():void{
			
			CollisionManager.getInstance().removeAllCollision();
		}
	     
	   public function dispose():void{
	   	    
	   	    if(swfPlayer!=null){
	   	    	if(swfPlayer.parent!=null){
	   	    		swfPlayer.parent.removeChild(swfPlayer);
			   	    MainSystem.getInstance().removeEventListener("zonghengsihai.complete",zongHengSiHai_fun);
			   	    swfPlayer.removeEventListener(Event.COMPLETE,on_swf_complete);
			   	    swfPlayer.dispose();
			   	    swfPlayer=null;
	   	    		
	   	    	}
	   	   }  	
	   }
    }
}
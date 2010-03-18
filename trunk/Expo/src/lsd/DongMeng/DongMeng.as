package lsd.DongMeng
{
	import communication.MainSystem;
	
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;
	
	import org.papervision3d.objects.primitives.Plane;
	public class DongMeng extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function DongMeng()
		{
			initPlayer();
		}
		private function initPlayer():void{
			
			flvPlayer=new FLVPlayer("movie/gx-dm1.flv",900,480,false);
		    MainSystem.getInstance().removePluginById("ZongHengSiHaiModule");
			addChild(flvPlayer);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
       }
       private function on_Complete(e:NetStatusEvent):void{
      	
      	    init();
      	    flvRemove();   	    
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
                flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
                flvPlayer=null;
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
		 	 CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"dm_gx")
		 	 CollisionManager.getInstance().addCollision(dongMengWindowArea,dongMengWindowClick,"dongMengWindow");
             //CollisionManager.getInstance().showCollision();

		 }
	  private function removeAreas():void{
			
			CollisionManager.getInstance().removeAllCollision();
		}
	     
	   public function dispose():void{
	   	    swfPlayer.parent.removeChild(swfPlayer);
	   	    swfPlayer.dispose();
	   	    swfPlayer=null;
	   	
	   }
       
		
	}
}
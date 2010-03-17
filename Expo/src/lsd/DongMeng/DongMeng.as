package lsd.DongMeng
{
	import communication.MainSystem;
	
	import flash.events.NetStatusEvent;
	
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
			init();
		}
		private function initPlayer():void{
			
			flvPlayer=new FLVPlayer("movie/dm-fz1.flv",900,480);
			addChild(flvPlayer);
			
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
       }
         private function on_Complete(e:NetStatusEvent):void{
      	
      	    init();
      	    flvRemove();
      	    MainSystem.getInstance().removePluginById("ZongHengSiHaiModule");
      	    
      	    
      }
      private function flvRemove():void
		{
			if (flvPlayer!=null)
			{
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			}
		}
	   private function init():void{
		 	
		 	 var guangXiArea:Array=[[[325,103],[387,128]]];
		 	 var dongMengWindowArea:Array=[[[660,110],[870,148]]];
		 	 swfPlayer=new SwfPlayer("swf/dongMeng.swf",900,480);
		 	 this.addChild(swfPlayer);
		 	 CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"dm_gx")
		 	 CollisionManager.getInstance().addCollision(dongMengWindowArea,dongMengWindowClick,"dongMengWindow");
             CollisionManager.getInstance().showCollision();

		 }
	  private function guangXiClick():void{
			trace("guangxi");
		}
	  private function dongMengWindowClick():void{
			trace("dongMeng");
		}
		 
	   public function dispose():void{
	   	
	   	
	   }
       
		
	}
}
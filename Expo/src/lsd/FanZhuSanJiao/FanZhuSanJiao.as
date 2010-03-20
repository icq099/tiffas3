package lsd.FanZhuSanJiao
{
	import communication.MainSystem;
	
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;

	public class FanZhuSanJiao extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function FanZhuSanJiao()
		{
			initPlayer();
			
		}
		private function initPlayer():void{
			
			flvPlayer=new FLVPlayer("movie/gx-fz1.flv",900,480,false);
			MainSystem.getInstance().removePluginById("ZongHengSiHaiModule");
			addChild(flvPlayer);
			trace("A")
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
      }
      private function on_Complete(e:NetStatusEvent):void{
      	    init();
      	    flvRemove();



      	    //MainSystem.getInstance().removePluginById("ZongHengSiHaiModule");

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
			flvPlayer=new FLVPlayer("movie/fz-gx1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,gx_Complete);	
		}
		private function gx_Complete(e:NetStatusEvent):void{
      	    
      	    MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
      	    MainSystem.getInstance().removePluginById("FanZhuSanJiaoModule");  
      	    flvRemove(); 
      }
		
		
		
		 private function init():void{
			
			 var guangXiArea:Array=[[[272,299],[394,377]],[[297,377],[347,410]]];
			 var fanZhuWindowArea:Array=[[[680,153],[892,192]]]
			 swfPlayer=new SwfPlayer("swf/fanZhuSanJiao.swf",980,490);
             CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"fz_gx");
			 CollisionManager.getInstance().addCollision(fanZhuWindowArea,fanZhuWindowClick,"fanZhuWindow");
			 this.addChild(swfPlayer);

			 
			 CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"fz_gx");
			 CollisionManager.getInstance().addCollision(fanZhuWindowArea,fanZhuWindowClick,"fanZhuWindow");

			 //CollisionManager.getInstance().showCollision();

		}
		private function removeAreas():void{
			
			CollisionManager.getInstance().removeAllCollision();
		}
	    
		
		private function fanZhuWindowClick():void{
			trace("fanzhuwindow");
		}
		public function dispose():void{
		  
				swfPlayer.parent.removeChild(swfPlayer);
				swfPlayer.dispose();
		        swfPlayer=null;
			}
		}
		
		
	}

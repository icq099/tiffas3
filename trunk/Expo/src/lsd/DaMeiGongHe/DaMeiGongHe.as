package lsd.DaMeiGongHe
{
	import communication.MainSystem;
    import flash.events.NetStatusEvent;
    import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.view.player.FLVPlayer;
	import flash.events.Event;
	import mx.core.UIComponent;
	
	public class DaMeiGongHe extends UIComponent
	{   
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function DaMeiGongHe()
		{
			initPlayer();
		}
		private function initPlayer():void{
			flvPlayer=new FLVPlayer("movie/gx-mgh1.flv",900,480,false);
		    MainSystem.getInstance().removePluginById("ZongHengSiHaiModule");
			addChild(flvPlayer);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
			
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
			flvPlayer=new FLVPlayer("movie/mgh-gx1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,gx_Complete);	
		}
	  private function gx_Complete(e:NetStatusEvent):void{
      	    
      	    MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
      	    MainSystem.getInstance().addEventListener("zonghengsihai.complete",zongHengSiHai_fun);
      }
       private function zongHengSiHai_fun(e:Event):void{
      	   
      	    MainSystem.getInstance().removePluginById("DaMeiGongHeModule");  
	        flvRemove(); 
      	
       }
       private function removeAreas():void{
			
			CollisionManager.getInstance().removeAllCollision();
		}
	    
		private function daMeiGongHeWindowClick():void{
			trace("dameigonghewindow");
		}
		
		private function init():void{
			swfPlayer=new SwfPlayer("swf/dameigonghe.swf",900,480);
			this.addChild(swfPlayer);
			swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
			var guangXiArea:Array=[[[485,129],[610,183]]];
			var daMeiGongHeWindowArea:Array=[[[670,185],[880,222]]];
			CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"dmg_gx");
			CollisionManager.getInstance().addCollision(daMeiGongHeWindowArea,daMeiGongHeWindowClick,"daMeiGongHeWindow");
			//CollisionManager.getInstance().showCollision();
         }
        private function on_swf_complete(e:Event):void
		{
			flvRemove();
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
  
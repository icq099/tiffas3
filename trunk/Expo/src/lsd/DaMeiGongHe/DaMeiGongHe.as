package lsd.DaMeiGongHe
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lsd.ZongHengSiHai.ZongHengSiHaiStatic;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;
	
	public class DaMeiGongHe extends UIComponent
	{   
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function DaMeiGongHe()
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
			flvPlayer=new FLVPlayer("movie/gx-mgh1.flv",900,480,false);
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
  
package lsd.FanZhuSanJiao
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

	public class FanZhuSanJiao extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function FanZhuSanJiao()
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
			
			flvPlayer=new FLVPlayer("movie/gx-fz1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(Event.COMPLETE,on_flv_complete);
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
			flvPlayer=new FLVPlayer("movie/fz-gx1.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,gx_Complete);	
		}
		private function gx_Complete(e:NetStatusEvent):void{
      	    
      	    MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
        
            MainSystem.getInstance().addEventListener("zonghengsihai.complete",zongHengSiHai_fun);
      	    //MainSystem.getInstance().removeEventListener("zonghengsihai.complete",zongHengSiHai_fun);
       }
      
       private function zongHengSiHai_fun(e:Event):void{
      	   
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
             swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);

			 CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"fz_gx");
			 CollisionManager.getInstance().addCollision(fanZhuWindowArea,fanZhuWindowClick,"fanZhuWindow");

			 //CollisionManager.getInstance().showCollision();

		}
		private function on_swf_complete(e:Event):void
		{
			flvRemove();
		}
		private function removeAreas():void{
			
			CollisionManager.getInstance().removeAllCollision();
		}
	    
		
		private function fanZhuWindowClick():void{
			trace("fanzhuwindow");
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

package lsd.ZongHengSiHai
{
	import caurina.transitions.Tweener;
	
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.LoadingMcManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.UIComponent;

	public class ZongHenSiHai extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function ZongHenSiHai(withMovie:Boolean)
		{   
			
			MainSystem.getInstance().stopRender();
			addZongHengSiHai(withMovie);
			
		}
		private function on_plugin_update():void
		{
			if(MainSystem.getInstance().isBusy==true)
			{
				MainSystem.getInstance().isBusy==false
				MainSystem.getInstance().removePluginById(ZongHengSiHaiStatic.getInstance().currentModuleName);
				removeAreas();
				
			}else
			{  
				MainSystem.getInstance().removePluginById(ZongHengSiHaiStatic.getInstance().currentModuleName);
			    removeAreas();
			}
		}
		public function addZongHengSiHai(withMovie:Boolean):void{
			if(withMovie)
			{   MainSystem.getInstance().isBusy=true;
				initPlayer();
			}else
			{   
				MainSystem.getInstance().isBusy=true;
				init();
			}
			
		}
		private function initPlayer():void
		{
			flvPlayer=new FLVPlayer("movie/donggu.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.READY,on_flv_complete);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
			
		}
		private function on_flv_complete(e:FLVPlayerEvent):void
		{   
			
			MainSystem.getInstance().addAutoClose(on_plugin_update,[]);
		}
		private function flvRemove():void
		{
		     
		     MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS,on_Complete);
		     MemoryRecovery.getInstance().gcObj(flvPlayer,true);
			
	
		}
		private function on_Complete(e:Event):void
		{     
			
			 
			  init();
		}
        private function init():void{
			
			LoadingMcManager.getInstance().loadingMcInit();
			swfPlayer=new SwfPlayer("swf/zongHengSiHai.swf",980,480);
			swfPlayer.y=0;
			 var daMeiGongHeArea:Array=[[[43,220],[157,301]]];
			 var dongMengArea:Array=[[[163,325],[282,395]]];
			 var fanZhuArea:Array=[[[580,296],[689,360]]];
			 var beiBuWanArea:Array=[[[326,342],[485,478]]];
			 var xiJiangArea:Array=[[[651,190],[734,220]]];
			 CollisionManager.getInstance().addCollision(dongMengArea,dongMengClick,"dongMeng");
			 CollisionManager.getInstance().addCollision(daMeiGongHeArea,daMeiGongHeClick,"daMeiGongHe");
			 CollisionManager.getInstance().addCollision(fanZhuArea,fanZhuClick,"fanzhu");
			 CollisionManager.getInstance().addCollision(beiBuWanArea,beiBuWanClick,"beiBuWan");
			 CollisionManager.getInstance().addCollision(xiJiangArea,xiJiangClick,"xiJiang");
			 this.addChild(swfPlayer);
			 LoadingMcManager.getInstance().loadingMcListener(swfPlayer);
			 swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
			  CollisionManager.getInstance().showCollision();
			 //swfPlayer.addEventListener(Event.COMPLETE,zongHengSiHai_complete);
	          
		}
		private function on_swf_complete(e:Event):void
		{   
			flvRemove();
			MainSystem.getInstance().isBusy=false;
			if(ZongHengSiHaiStatic.getInstance().currentModuleName=="ZongHengSiHaiModule")
			{
				MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			}
			MainSystem.getInstance().addAutoClose(on_plugin_update,[]);
		}
	
		/* private function zongHengSiHai_complete(e:Event):void{
			
			 MainSystem.getInstance().dispatchEvent(new Event("zonghengsihai.complete"));
		} */
		
       private function daMeiGongHeClick():void
		{
				trace("daMeiGongHe");
				MainSystem.getInstance().showPluginById("DaMeiGongHeModule");
			    removeAreas();
		}
		private function dongMengClick():void
		{
				trace("dongmeng");
				MainSystem.getInstance().showPluginById("DongMengModule")
				removeAreas();
		}
		private function fanZhuClick():void
		{
				trace("fanzhu");
				
				MainSystem.getInstance().showPluginById("FanZhuSanJiaoModule");
			    removeAreas();
			    
				
		}
		private function beiBuWanClick():void
		{
				trace("beibuwan");
		}
		private function xiJiangClick():void
		{
				trace("xiJiang");
		}
		private function removeAreas():void{
			
			
			CollisionManager.getInstance().removeAllCollision();
			
		}
		public function dispose():void{
			Tweener.addTween(this,{alpha:0,time:1,onComplete:close});
        }
         private function close():void
         {  
         	LoadingMcManager.getInstance().dispose();
         	MemoryRecovery.getInstance().gcFun(swfPlayer,Event.COMPLETE,on_swf_complete);
         	MemoryRecovery.getInstance().gcObj(swfPlayer,true);
         	
           
         }
	}
}
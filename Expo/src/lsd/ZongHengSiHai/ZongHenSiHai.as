package lsd.ZongHengSiHai
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.view.player.FLVPlayer;
	
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
		public function addZongHengSiHai(withMovie:Boolean):void{
			if(withMovie)
			{
				initPlayer();
			}else
			{
				init();
			}
			
		}
		private function initPlayer():void
		{
			flvPlayer=new FLVPlayer("movie/donggu.flv",900,480,false);
			addChild(flvPlayer);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
			
		}
		private function flvRemove():void
		{
			if (flvPlayer!=null)
			{   
				if(flvPlayer.hasEventListener(NetStatusEvent.NET_STATUS))
				{
					flvPlayer.removeEventListener(NetStatusEvent.NET_STATUS,on_Complete);
				}
				if(flvPlayer.parent!=null){
                flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
                flvPlayer=null;
              }
		   }
		}
		
		
		
		private function on_Complete(e:Event):void
		{
			init();
		}
		
        private function init():void{
			
			swfPlayer=new SwfPlayer("swf/zongHengSiHai.swf",980,490);
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
			 swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
			 swfPlayer.addEventListener(Event.COMPLETE,zongHengSiHai_complete);
	          
		}
		private function on_swf_complete(e:Event):void
		{
			flvRemove();
		}
	
		private function zongHengSiHai_complete(e:Event):void{
			
			 MainSystem.getInstance().dispatchEvent(new Event("zonghengsihai.complete"));
		}
		
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
			 if(swfPlayer!=null){
			 	if(swfPlayer.parent!=null){
			 		swfPlayer.parent.removeChild(swfPlayer);
					swfPlayer.removeEventListener(Event.COMPLETE,on_swf_complete);
					swfPlayer.removeEventListener(Event.COMPLETE,zongHengSiHai_complete);
					swfPlayer.dispose();
			        swfPlayer=null;
			 		
			 	}
			 }
         }
	}
}
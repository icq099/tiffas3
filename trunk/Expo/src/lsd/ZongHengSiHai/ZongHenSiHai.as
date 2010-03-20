package lsd.ZongHengSiHai
{
	import communication.MainSystem;
	
	import flash.events.Event;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	
	import mx.core.UIComponent;

	public class ZongHenSiHai extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		public function ZongHenSiHai()
		{
			init();
		}
		
		private function init():void{
			
			 MainSystem.getInstance().disable360System();
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
			 swfPlayer.addEventListener(Event.COMPLETE,function(e:Event):void{
				 MainSystem.getInstance().dispatchEvent(new Event("zonghengsihai.complete"));
			 });
			// CollisionManager.getInstance().showCollision();
				
	          
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
			
				swfPlayer.parent.removeChild(swfPlayer);
				swfPlayer.dispose();
		        swfPlayer=null;
		}
		
		

	}
}
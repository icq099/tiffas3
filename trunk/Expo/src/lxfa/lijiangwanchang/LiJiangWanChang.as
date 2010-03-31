package lxfa.lijiangwanchang
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.utils.MemoryRecovery;
	
	import mx.core.Application;
	
	public class LiJiangWanChang
	{
		private var fishingGame:FishingGame;
		private var liJiangWanChangSwc:LiJiangWanChangSwc;
		public function LiJiangWanChang()
		{
			MainSystem.getInstance().addAPI("getLiJiangWanCHang",init);
		}
		private function init():LiJiangWanChangSwc
		{
			liJiangWanChangSwc=new LiJiangWanChangSwc();
			liJiangWanChangSwc.btn_close.addEventListener(MouseEvent.CLICK,onbtn_closeClick);
			liJiangWanChangSwc.btn_fishing.addEventListener(MouseEvent.CLICK,onbtn_fishingClick);
			return liJiangWanChangSwc;
		}
		private function onbtn_closeClick(e:MouseEvent):void
		{
			liJiangWanChangSwc.dispatchEvent(new Event(Event.CLOSE));
			MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["LiJiangWanChangModule"]);
		}
		private function onbtn_fishingClick(e:MouseEvent):void
		{
			MemoryRecovery.getInstance().gcFun(liJiangWanChangSwc.btn_fishing,MouseEvent.CLICK,onbtn_fishingClick);
			if(fishingGame==null)
			{
				fishingGame=new FishingGame();
				fishingGame.addEventListener(Event.COMPLETE,onfishingGameComplete);
				fishingGame.addEventListener(Event.CLOSE,on_fishGame_close);
			}
			else
			{
				popupFishGame();
			}
		}
		private function on_fishGame_close(e:Event):void
		{
			MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["LiJiangWanChangModule"]);
			liJiangWanChangSwc.dispatchEvent(e);
		}
		private function popupFishGame():void
		{
			liJiangWanChangSwc.parent.addChild(fishingGame);
			liJiangWanChangSwc.parent.removeChild(liJiangWanChangSwc);
			fishingGame.x=10;
			fishingGame.y=20;
		}
		private function onfishingGameComplete(e:Event):void
		{
			popupFishGame();
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(liJiangWanChangSwc.btn_close,MouseEvent.CLICK,onbtn_closeClick);
			MemoryRecovery.getInstance().gcFun(liJiangWanChangSwc.btn_fishing,MouseEvent.CLICK,onbtn_fishingClick);
			MemoryRecovery.getInstance().gcObj(liJiangWanChangSwc.btn_close);
			MemoryRecovery.getInstance().gcObj(liJiangWanChangSwc.btn_fishing);
			MemoryRecovery.getInstance().gcObj(liJiangWanChangSwc);
			MemoryRecovery.getInstance().gcFun(fishingGame,Event.COMPLETE,onfishingGameComplete);
			MemoryRecovery.getInstance().gcFun(fishingGame,Event.CLOSE,on_fishGame_close);
			MemoryRecovery.getInstance().gcObj(fishingGame,true);
		}
	}
}
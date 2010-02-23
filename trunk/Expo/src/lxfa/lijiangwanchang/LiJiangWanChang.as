package lxfa.lijiangwanchang
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	public class LiJiangWanChang extends LiJiangWanChangSwc
	{
		private var fishingGame:FishingGame;
		public function LiJiangWanChang()
		{
			super();
			initListener();
		}
		private function initListener():void
		{
			this.btn_close.addEventListener(MouseEvent.CLICK,onbtn_closeClick);
			this.btn_fishing.addEventListener(MouseEvent.CLICK,onbtn_fishingClick);
		}
		private function onbtn_closeClick(e:MouseEvent):void
		{
			
		}
		private function onbtn_fishingClick(e:MouseEvent):void
		{
			if(fishingGame==null)
			{
				fishingGame=new FishingGame();
				fishingGame.addEventListener(Event.COMPLETE,onfishingGameComplete);
			}
			else
			{
				popupFishGame();
			}
		}
		private function popupFishGame():void
		{
			PopUpManager.addPopUp(fishingGame,this, true);
	        PopUpManager.centerPopUp(fishingGame); 
			fishingGame.x=40;
			fishingGame.y=90;
		}
		private function onfishingGameComplete(e:Event):void
		{
			popupFishGame();
		}
	}
}
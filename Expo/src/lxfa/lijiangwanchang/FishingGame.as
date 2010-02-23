package lxfa.lijiangwanchang
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class FishingGame extends UIComponent
	{
		private var fishingSwc:FishingSwc
		private var swfPlayer:SwfPlayer;
		public function FishingGame()
		{
			super();
			initFishingSwc();
			initSwfPlayer();
		}
		private function initFishingSwc():void
		{
			fishingSwc=new FishingSwc();
			this.addChild(fishingSwc);
			fishingSwc.btn_close.addEventListener(MouseEvent.CLICK,onbtn_closeClick);
		}
		private function initSwfPlayer():void
		{
			swfPlayer=new SwfPlayer("swf/lijiangwanchang.swf",775,329);
			swfPlayer.x=22;
			swfPlayer.y=24;
			swfPlayer.addEventListener(Event.COMPLETE,onswfPlayerComplete);
		}
		private function onswfPlayerComplete(e:Event):void
		{
			this.addChild(swfPlayer);
			this.dispatchEvent(e);
		}
		private function onbtn_closeClick(e:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
	}
}
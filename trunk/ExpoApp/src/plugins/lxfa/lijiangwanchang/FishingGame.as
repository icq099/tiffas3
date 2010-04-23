package plugins.lxfa.lijiangwanchang
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import memory.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	import view.player.SwfPlayer;
	
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
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(swfPlayer,Event.COMPLETE,onswfPlayerComplete);
			swfPlayer.unloadAndStop();
			if(swfPlayer!=null)
			{
				if(swfPlayer.parent!=null)
				{
					swfPlayer.parent.removeChild(swfPlayer);
				}
				swfPlayer=null;
			}
			MemoryRecovery.getInstance().gcFun(fishingSwc.btn_close,MouseEvent.CLICK,onbtn_closeClick);
			if(fishingSwc.btn_close!=null)
			{
				if(fishingSwc.btn_close.parent!=null)
				{
					fishingSwc.btn_close.parent.removeChild(fishingSwc.btn_close);
				}
				fishingSwc.btn_close=null;
			}
			if(fishingSwc!=null)
			{
				if(fishingSwc.parent!=null)
				{
					fishingSwc.parent.removeChild(fishingSwc);
				}
				fishingSwc=null;
			}
		}
	}
}
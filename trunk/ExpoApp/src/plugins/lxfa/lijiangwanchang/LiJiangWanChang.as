package plugins.lxfa.lijiangwanchang
{
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import memory.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	public class LiJiangWanChang extends UIComponent
	{
		private var fishingGame:FishingGame;
		private var liJiangWanChangSwc:LiJiangWanChangSwc;
		public function LiJiangWanChang()
		{
			init();
		}
		private function init():void
		{
			liJiangWanChangSwc=new LiJiangWanChangSwc();
			liJiangWanChangSwc.btn_close.addEventListener(MouseEvent.CLICK,onbtn_closeClick);
			liJiangWanChangSwc.btn_fishing.addEventListener(MouseEvent.CLICK,onbtn_fishingClick);
			this.addChild(liJiangWanChangSwc);
		}
		private function onbtn_closeClick(e:MouseEvent):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				PluginManager.getInstance().removePluginById("LiJiangWanChangModule");
			}
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
		
		private function mouseover_fun(e:Event):void{
			
			Mouse.show();
		}
		private function mouseout_fun(e:Event):void{
			
			Mouse.show();
		}
		
		private function on_fishGame_close(e:Event):void
		{
			PluginManager.getInstance().removePluginById("LiJiangWanChangModule");
		}
		private function popupFishGame():void
		{
			liJiangWanChangSwc.parent.addChild(fishingGame);
			liJiangWanChangSwc.parent.removeChild(liJiangWanChangSwc);
			fishingGame.x=10;
			fishingGame.y=20;
			fishingGame.addEventListener(MouseEvent.MOUSE_OVER,mouseover_fun);
			fishingGame.addEventListener(MouseEvent.MOUSE_OUT,mouseout_fun);
		}
		private function onfishingGameComplete(e:Event):void
		{
			popupFishGame();
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(liJiangWanChangSwc.btn_close,MouseEvent.CLICK,onbtn_closeClick);
			MemoryRecovery.getInstance().gcFun(liJiangWanChangSwc.btn_fishing,MouseEvent.CLICK,onbtn_fishingClick);
			if(liJiangWanChangSwc.btn_close!=null)
			{
				if(liJiangWanChangSwc.btn_close.parent!=null)
				{
					liJiangWanChangSwc.btn_close.parent.removeChild(liJiangWanChangSwc.btn_close);
				}
				liJiangWanChangSwc.btn_close=null;
			}
			if(liJiangWanChangSwc.btn_fishing!=null)
			{
				if(liJiangWanChangSwc.btn_fishing.parent!=null)
				{
					liJiangWanChangSwc.btn_fishing.parent.removeChild(liJiangWanChangSwc.btn_fishing);
				}
				liJiangWanChangSwc.btn_fishing=null;
			}
			if(liJiangWanChangSwc!=null)
			{
				if(liJiangWanChangSwc.parent!=null)
				{
					liJiangWanChangSwc.parent.removeChild(liJiangWanChangSwc);
				}
				liJiangWanChangSwc=null;
			}
			MemoryRecovery.getInstance().gcFun(fishingGame,Event.COMPLETE,onfishingGameComplete);
			MemoryRecovery.getInstance().gcFun(fishingGame,Event.CLOSE,on_fishGame_close);
			MemoryRecovery.getInstance().gcFun(fishingGame,MouseEvent.MOUSE_OVER,mouseover_fun);
			MemoryRecovery.getInstance().gcFun(fishingGame,MouseEvent.MOUSE_OUT,mouseout_fun);
			if(fishingGame!=null)
			{
				if(fishingGame.parent!=null)
				{
					fishingGame.parent.removeChild(fishingGame);
				}
				fishingGame.dispose();
				fishingGame=null;
			}
		}
	}
}
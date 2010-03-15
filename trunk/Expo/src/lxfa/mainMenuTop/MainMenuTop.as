package lxfa.mainMenuTop
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	
	public class MainMenuTop extends Sprite
	{
		private var top:MainMenuTopSwc;
		private var hasBackGround:Boolean=true;
		public function MainMenuTop()
		{
			top=new MainMenuTopSwc();
			this.addChild(top);
			initLaba();
		}
		private function initLaba():void
		{
			top.laba.buttonMode=true;
			top.laba.stop();
			top.laba.addEventListener(MouseEvent.CLICK,on_laba_click);
		}
		private function on_laba_click(e:MouseEvent):void
		{
			if(hasBackGround)
			{
				top.laba.gotoAndStop(2);
				hasBackGround=false;
				MainSystem.getInstance().runAPIDirect("stopSound",[]);
			}
			else
			{
				top.laba.gotoAndStop(1);
				hasBackGround=true;
				MainSystem.getInstance().runAPIDirect("playSound",[]);
			}
		}
	}
}
package lxfa.mainMenu
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	public class MainMenu extends Sprite
	{
		private var mainMenuSwc:MainMenuSwc;
		public function MainMenu()
		{
			initMainMenuSwc();
			initEvent();
		}
		private function initMainMenuSwc():void
		{
			var ui:UIComponent=new UIComponent();
			mainMenuSwc=new MainMenuSwc();
			ui.addChild(mainMenuSwc);
			this.addChild(ui);
		}
		private function initEvent():void
		{
			mainMenuSwc.cameraAdd.addEventListener(MouseEvent.CLICK,cameraAddClickEvent);
			mainMenuSwc.cameraNotAdd.addEventListener(MouseEvent.CLICK,cameraNotAddClickEvent);
			mainMenuSwc.help.addEventListener(MouseEvent.CLICK,helpClickEvent);
			mainMenuSwc.cameraUp.addEventListener(MouseEvent.CLICK,cameraUpClickEvent);
			mainMenuSwc.cameraDown.addEventListener(MouseEvent.CLICK,cameraDownClickEvent);
			mainMenuSwc.cameraLeft.addEventListener(MouseEvent.CLICK,cameraLeftClickEvent);
			mainMenuSwc.cameraRight.addEventListener(MouseEvent.CLICK,cameraRightClickEvent);
		}
		///////////////////////////////////////////按钮点击事件///////////////////////////////////////
		private function cameraAddClickEvent(e:MouseEvent):void
		{
			trace("cameraAddClickEvent");
		}
		private function cameraNotAddClickEvent(e:MouseEvent):void
		{
			trace("cameraNotAddClickEvent");
		}
		private function helpClickEvent(e:MouseEvent):void
		{
			trace("helpClickEvent");
		}
		private function cameraUpClickEvent(e:MouseEvent):void
		{
			trace("cameraUpClickEvent");
		}
		private function cameraDownClickEvent(e:MouseEvent):void
		{
			trace("cameraDownClickEvent");
		}
		private function cameraLeftClickEvent(e:MouseEvent):void
		{
			trace("cameraLeftClickEvent");
		}
		private function cameraRightClickEvent(e:MouseEvent):void
		{
			trace("cameraRightClickEvent");
		}
	}
}
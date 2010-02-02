package lxfa.mainMenuBottom
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MainMenuBottom extends Sprite
	{
		private var bottom:MainMenuSwcBottom;
		private const cameraRotateSpeed:int=8;
		public function MainMenuBottom()
		{
			initbottom();
			initEvent();
		}
		private function initbottom():void
		{
			bottom=new MainMenuSwcBottom();
			this.addChild(bottom);
		}
		private function initEvent():void
		{
			bottom.cameraAdd.addEventListener(MouseEvent.CLICK,cameraAddClickEvent);
			bottom.cameraNotAdd.addEventListener(MouseEvent.CLICK,cameraNotAddClickEvent);
			bottom.help.addEventListener(MouseEvent.CLICK,helpClickEvent);
			bottom.cameraUp.addEventListener(MouseEvent.CLICK,cameraUpClickEvent);
			bottom.cameraDown.addEventListener(MouseEvent.CLICK,cameraDownClickEvent);
			bottom.cameraLeft.addEventListener(MouseEvent.CLICK,cameraLeftClickEvent);
			bottom.cameraRight.addEventListener(MouseEvent.CLICK,cameraRightClickEvent);
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
			trace("upClickEvent");
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
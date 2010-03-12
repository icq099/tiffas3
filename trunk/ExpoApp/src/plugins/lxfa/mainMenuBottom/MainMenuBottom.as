package plugins.lxfa.mainMenuBottom
{
	import core.communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	
	public class MainMenuBottom extends Sprite
	{
		private var bottom:MainMenuSwcBottom;
		private const cameraRotateSpeed:int=8;
		private const focusMaxRange:int=130;
		private const focusMinRange:int=60;
		private var focusSpeed:int=10;
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
			Application.application.stage.addEventListener(KeyboardEvent.KEY_DOWN,stageKeyEvent);
		}
		///////////////////////////////////键盘事件
		private function stageKeyEvent(e:KeyboardEvent):void
		{
			if(e.keyCode==37)
			{
//				MainSystem.getInstance().camera.rotationY-=cameraRotateSpeed;
			}else if(e.keyCode==38)
			{
//				MainSystem.getInstance().camera.rotationX+=cameraRotateSpeed;
			}else if(e.keyCode==39)
			{
//				MainSystem.getInstance().camera.rotationY+=cameraRotateSpeed;
			}else if(e.keyCode==40)
			{
//				MainSystem.getInstance().camera.rotationX-=cameraRotateSpeed;
			}
		}
		///////////////////////////////////////////按钮点击事件///////////////////////////////////////
		private var tempFocus:int=0;
		private function cameraAddClickEvent(e:MouseEvent):void
		{
//			tempFocus=MainSystem.getInstance().camera.focus+focusSpeed;
			if(tempFocus<focusMaxRange)
			{
//				MainSystem.getInstance().camera.focus+=focusSpeed;
			}
		}
		private function cameraNotAddClickEvent(e:MouseEvent):void
		{
//			tempFocus=MainSystem.getInstance().camera.focus-focusSpeed;
			if(tempFocus>focusMinRange)
			{
//				MainSystem.getInstance().camera.focus-=focusSpeed;
			}
		}
		private function helpClickEvent(e:MouseEvent):void
		{
			trace("helpClickEvent");
		}
		private function cameraUpClickEvent(e:MouseEvent):void
		{
//			MainSystem.getInstance().camera.rotationX+=cameraRotateSpeed;
		}
		private function cameraDownClickEvent(e:MouseEvent):void
		{
//			MainSystem.getInstance().camera.rotationX-=cameraRotateSpeed;
		}
		private function cameraLeftClickEvent(e:MouseEvent):void
		{
//			MainSystem.getInstance().camera.rotationY-=cameraRotateSpeed;
		}
		private function cameraRightClickEvent(e:MouseEvent):void
		{
//			MainSystem.getInstance().camera.rotationY+=cameraRotateSpeed;
		}
	}
}
package lxfa.mainMenuBottom
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	
	public class MainMenuBottom extends Sprite
	{
		private var bottom:MainMenuBottomSwc;
		private const cameraRotateSpeed:int=8;
		private const focusMaxRange:int=110;
		private const focusMinRange:int=60;
		private var focusSpeed:int=10;
		private var currentSceneId:int=-1;//当前场景的编号
		public function MainMenuBottom()
		{
			initbottom();
		}
		private function initbottom():void
		{
			if(bottom==null)
			{
				bottom=new MainMenuBottomSwc();
				initEvent();
			}
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
			bottom.lvsejiayuan.addEventListener(MouseEvent.CLICK,on_lvsejiayuan_click);
			bottom.lansemengxiang.addEventListener(MouseEvent.CLICK,on_lansemengxiang_click);
			bottom.meiguantianxia.addEventListener(MouseEvent.CLICK,on_meiguantianxia_click);
			bottom.jingxiuhuazhang.addEventListener(MouseEvent.CLICK,on_jingxiuhuazhang_click);
			bottom.shengshihexie.addEventListener(MouseEvent.CLICK,on_shengshihexie_click);
			bottom.zonghengsihai.addEventListener(MouseEvent.CLICK,on_zonghengsihai_click);
			bottom.yangmengbagui.addEventListener(MouseEvent.CLICK,on_yangmengbagui_click);
		}
		//场景按钮事件
		private function on_lvsejiayuan_click(e:MouseEvent):void
		{
			customGotoScene(0);
		}
		private function on_lansemengxiang_click(e:MouseEvent):void
		{
			customGotoScene(1);
		}
		private function on_meiguantianxia_click(e:MouseEvent):void
		{
			customGotoScene(2);
		}
		private function on_jingxiuhuazhang_click(e:MouseEvent):void
		{
			customGotoScene(3);
		}
		private function on_shengshihexie_click(e:MouseEvent):void
		{
			customGotoScene(4);
		}
		private function customGotoScene(id:int):void
		{
			if(!MainSystem.getInstance().isBusy && currentSceneId!=id)
			{
				currentSceneId=id;
				MainSystem.getInstance().enable360System();
				MainSystem.getInstance().startRender();
				MainSystem.getInstance().gotoScene(id);
			}
		}
		private function on_zonghengsihai_click(e:MouseEvent):void//纵横四海
		{
			if(currentSceneId!=5 && !MainSystem.getInstance().isBusy)
			{
				currentSceneId=5;
				MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
			}
		}
		private function on_yangmengbagui_click(e:MouseEvent):void//杨梦八桂
		{
			if(currentSceneId!=6 &&  !MainSystem.getInstance().isBusy)
			{
				currentSceneId=6;
				MainSystem.getInstance().showPluginById("YangMengBaGuiModule");
			}
		}
		//下面的没BUG，可以不用看
		///////////////////////////////////键盘事件
		private function stageKeyEvent(e:KeyboardEvent):void
		{
			if(MainSystem.getInstance().camera!=null)
			{
				if(e.keyCode==37)
				{
					MainSystem.getInstance().camera.rotationY-=cameraRotateSpeed;
				}else if(e.keyCode==38)
				{
					MainSystem.getInstance().camera.rotationX+=cameraRotateSpeed;
				}else if(e.keyCode==39)
				{
					MainSystem.getInstance().camera.rotationY+=cameraRotateSpeed;
				}else if(e.keyCode==40)
				{
					MainSystem.getInstance().camera.rotationX-=cameraRotateSpeed;
				}
			}
		}
		///////////////////////////////////////////按钮点击事件///////////////////////////////////////
		private var tempFocus:int=0;
		private function cameraAddClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().camera!=null)
			{
				tempFocus=MainSystem.getInstance().camera.focus+focusSpeed;
				if(tempFocus<focusMaxRange)
				{
					MainSystem.getInstance().camera.focus+=focusSpeed;
				}
			}
		}
		private function cameraNotAddClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().camera!=null)
			{
				tempFocus=MainSystem.getInstance().camera.focus-focusSpeed;
				if(tempFocus>focusMinRange)
				{
					MainSystem.getInstance().camera.focus-=focusSpeed;
				}
			}
		}
		private function helpClickEvent(e:MouseEvent):void
		{
			trace("helpClickEvent");
		}
		private function cameraUpClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().camera!=null)
			{
				MainSystem.getInstance().camera.rotationX+=cameraRotateSpeed;
			}
		}
		private function cameraDownClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().camera!=null)
			{
				MainSystem.getInstance().camera.rotationX-=cameraRotateSpeed;
			}
		}
		private function cameraLeftClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().camera!=null)
			{
				MainSystem.getInstance().camera.rotationY-=cameraRotateSpeed;
			}
		}
		private function cameraRightClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().camera!=null)
			{
				MainSystem.getInstance().camera.rotationY+=cameraRotateSpeed;
			}
		}
	}
}
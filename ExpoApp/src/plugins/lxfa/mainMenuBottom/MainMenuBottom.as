package plugins.lxfa.mainMenuBottom
{
	import caurina.transitions.Tweener;
	
	import core.manager.MainSystem;
	import core.manager.sceneManager.event.SceneChangeEvent;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	
	import plugins.lxfa.mainMenuTop.MainMenu;
	
	public class MainMenuBottom extends MainMenu
	{
		private var bottom:MainMenuBottomSwc;
		private var bottomSign:MainMenuBottomSign;
		private const cameraRotateSpeed:int=8;
		private const focusMaxRange:int=120;
		private const focusMinRange:int=60;
		private var focusSpeed:int=5;
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
			bottom.alpha=0;
			Tweener.addTween(bottom,{alpha:1,time:3});
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
			bottomSign=new MainMenuBottomSign();
			bottom.addChild(bottomSign);
			bottomSign.y=500;
			MainSystem.getInstance().addEventListener(SceneChangeEvent.INIT,changeColor);
		}
		private function changeColor(e:SceneChangeEvent):void
		{
			if(e.id==0)
			{
				bottomSign.x=bottom.lvsejiayuan.x;
				bottomSign.y=bottom.lvsejiayuan.y;
			}else if(e.id==1)
			{
				bottomSign.x=bottom.lansemengxiang.x;
				bottomSign.y=bottom.lansemengxiang.y;
			}else if(e.id==2)
			{
				bottomSign.x=bottom.meiguantianxia.x;
				bottomSign.y=bottom.meiguantianxia.y;
			}else if(e.id==3)
			{
				bottomSign.x=bottom.jingxiuhuazhang.x;
				bottomSign.y=bottom.jingxiuhuazhang.y;
			}else if(e.id==4)
			{
				bottomSign.x=bottom.shengshihexie.x;
				bottomSign.y=bottom.shengshihexie.y;
			}else if(e.id==5)
			{
				bottomSign.x=bottom.zonghengsihai.x;
				bottomSign.y=bottom.zonghengsihai.y;
			}else if(e.id==6)
			{
				bottomSign.x=bottom.yangmengbagui.x;
				bottomSign.y=bottom.yangmengbagui.y;
			}
		}
		//场景按钮事件
		private function on_lvsejiayuan_click(e:MouseEvent):void
		{
			customGoto3DScene(0);
		}
		private function on_lansemengxiang_click(e:MouseEvent):void
		{
			customGoto3DScene(1);
		}
		private function on_meiguantianxia_click(e:MouseEvent):void
		{
			customGoto3DScene(2);
		}
		private function on_jingxiuhuazhang_click(e:MouseEvent):void
		{
			customGoto3DScene(3);
		}
		private function on_shengshihexie_click(e:MouseEvent):void
		{
			customGoto3DScene(4);
		}
		private function on_zonghengsihai_click(e:MouseEvent):void//纵横四海
		{
			customGoto2DScene(5,"ZongHengSiHaiModule");
		}
		private function on_yangmengbagui_click(e:MouseEvent):void//杨梦八桂
		{
			customGoto2DScene(6,"YangMengBaGuiModule");
		}
		//下面的没BUG，可以不用看
		///////////////////////////////////键盘事件
		private function stageKeyEvent(e:KeyboardEvent):void
		{
//			if(MainSystem.getInstance().camera!=null)
//			{
//				if(e.keyCode==37)
//				{
//					MainSystem.getInstance().camera.rotationY-=cameraRotateSpeed;
//				}else if(e.keyCode==38)
//				{
//					MainSystem.getInstance().camera.rotationX+=cameraRotateSpeed;
//				}else if(e.keyCode==39)
//				{
//					MainSystem.getInstance().camera.rotationY+=cameraRotateSpeed;
//				}else if(e.keyCode==40)
//				{
//					MainSystem.getInstance().camera.rotationX-=cameraRotateSpeed;
//				}
//			}
		}
		///////////////////////////////////////////按钮点击事件///////////////////////////////////////
		private var tempFocus:int=0;
		private function cameraAddClickEvent(e:MouseEvent):void
		{
//			if(MainSystem.getInstance().camera!=null)
//			{
//				tempFocus=MainSystem.getInstance().camera.focus+focusSpeed;
//				if(tempFocus<focusMaxRange)
//				{
//					MainSystem.getInstance().camera.focus+=focusSpeed;
//				}
//			}
		}
		private function cameraNotAddClickEvent(e:MouseEvent):void
		{
//			if(MainSystem.getInstance().camera!=null)
//			{
//				tempFocus=MainSystem.getInstance().camera.focus-focusSpeed;
//				if(tempFocus>focusMinRange)
//				{
//					MainSystem.getInstance().camera.focus-=focusSpeed;
//				}
//			}
		}
		private function helpClickEvent(e:MouseEvent):void
		{
			trace("helpClickEvent");
		}
		private function cameraUpClickEvent(e:MouseEvent):void
		{
//			if(MainSystem.getInstance().camera!=null)
//			{
//				MainSystem.getInstance().camera.rotationX+=cameraRotateSpeed;
//			}
		}
		private function cameraDownClickEvent(e:MouseEvent):void
		{
//			if(MainSystem.getInstance().camera!=null)
//			{
//				MainSystem.getInstance().camera.rotationX-=cameraRotateSpeed;
//			}
		}
		private function cameraLeftClickEvent(e:MouseEvent):void
		{
//			if(MainSystem.getInstance().camera!=null)
//			{
//				MainSystem.getInstance().camera.rotationY-=cameraRotateSpeed;
//			}
		}
		private function cameraRightClickEvent(e:MouseEvent):void
		{
//			if(MainSystem.getInstance().camera!=null)
//			{
//				MainSystem.getInstance().camera.rotationY+=cameraRotateSpeed;
//			}
		}
	}
}
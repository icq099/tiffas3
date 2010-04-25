package plugins.lxfa.mainMenuBottom
{
	import caurina.transitions.Tweener;
	
	import core.manager.MainSystem;
	import core.manager.sceneManager.SceneManager;
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import memory.MemoryRecovery;
	
	import mx.core.Application;
	
	import plugins.lxfa.mainMenuTop.MainMenu;
	
	public class MainMenuBottom extends MainMenu
	{
		private var bottom:MainMenuBottomSwc;
		private var bottomSign:MainMenuBottomSign;
		private const cameraRotateSpeed:int=8;
		private const focusMaxRange:int=450;
		private const focusMinRange:int=250;
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
			bottom.alpha=0;
			Tweener.addTween(bottom,{alpha:1,time:3});
		}
		private function initEvent():void
		{
			bottom.cameraAdd.addEventListener(MouseEvent.CLICK,cameraAddClickEvent);
			bottom.cameraNotAdd.addEventListener(MouseEvent.CLICK,cameraNotAddClickEvent);
			bottom.help.addEventListener(MouseEvent.CLICK,helpClickEvent);
			bottom.cameraUp.addEventListener(MouseEvent.MOUSE_DOWN,cameraUpMouseDownEvent);
			bottom.cameraUp.addEventListener(MouseEvent.MOUSE_UP,cameraUpMouseUpEvent);
			bottom.cameraDown.addEventListener(MouseEvent.MOUSE_DOWN,cameraDownMouseDownEvent);
			bottom.cameraDown.addEventListener(MouseEvent.MOUSE_UP,cameraDownMouseUpEvent);
			bottom.cameraLeft.addEventListener(MouseEvent.MOUSE_DOWN,cameraLeftMouseDownEvent);
			bottom.cameraLeft.addEventListener(MouseEvent.MOUSE_UP,cameraLeftMouseUpEvent);
			bottom.cameraRight.addEventListener(MouseEvent.MOUSE_DOWN,cameraRightMouseDownEvent);
			bottom.cameraRight.addEventListener(MouseEvent.MOUSE_UP,cameraRightMouseUpEvent);
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
			SceneManager.getInstance().gotoScene(0);
		}
		private function on_lansemengxiang_click(e:MouseEvent):void
		{
			SceneManager.getInstance().gotoScene(1);
		}
		private function on_meiguantianxia_click(e:MouseEvent):void
		{
			SceneManager.getInstance().gotoScene(2);
		}
		private function on_jingxiuhuazhang_click(e:MouseEvent):void
		{
			SceneManager.getInstance().gotoScene(3);
		}
		private function on_shengshihexie_click(e:MouseEvent):void
		{
			SceneManager.getInstance().gotoScene(4);
		}
		private function on_zonghengsihai_click(e:MouseEvent):void//纵横四海
		{
			SceneManager.getInstance().gotoScene(5);
		}
		private function on_yangmengbagui_click(e:MouseEvent):void//杨梦八桂
		{
			SceneManager.getInstance().gotoScene(6);
		}
		//下面的没BUG，可以不用看
		///////////////////////////////////键盘事件
		private function stageKeyEvent(e:KeyboardEvent):void
		{
			if(MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA)!=null)
			{
				if(e.keyCode==37)
				{
					MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[0,-cameraRotateSpeed]);
				}else if(e.keyCode==38)
				{
					MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[cameraRotateSpeed,0]);
				}else if(e.keyCode==39)
				{
					MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[0,cameraRotateSpeed]);
				}else if(e.keyCode==40)
				{
					MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[-cameraRotateSpeed,0]);
				}
			}
		}
		///////////////////////////////////////////按钮点击事件///////////////////////////////////////
		private var tempFocus:int=0;
		private function cameraAddClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA)!=null)
			{
				tempFocus=MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA).focus+focusSpeed;
				if(tempFocus<focusMaxRange)
				{
					MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA).focus+=focusSpeed;
				}
			}
		}
		private function cameraNotAddClickEvent(e:MouseEvent):void
		{
			if(MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA)!=null)
			{
				tempFocus=MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA).focus-focusSpeed;
				if(tempFocus>focusMinRange)
				{
					MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA).focus-=focusSpeed;
				}
			}
		}
		private function helpClickEvent(e:MouseEvent):void
		{
			trace("helpClickEvent");
		}
		//上风车
		private function cameraUpMouseDownEvent(e:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME,upEnterFrame);
		}
		private function upEnterFrame(e:Event):void
		{
			if(MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA)!=null)
			{
				MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[cameraRotateSpeed,0]);
			}
		}
		private function cameraUpMouseUpEvent(e:MouseEvent):void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,upEnterFrame);
		}
		//下风车
		private function cameraDownMouseDownEvent(e:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME,downEnterFrame);
		}
		private function cameraDownMouseUpEvent(e:MouseEvent):void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,downEnterFrame);
		}
		private function downEnterFrame(e:Event):void
		{
			if(MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA)!=null)
			{
				MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[-cameraRotateSpeed,0]);
			}
		}
		//左风车
		private function cameraLeftMouseDownEvent(e:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME,leftEnterFrame);
		}
		private function cameraLeftMouseUpEvent(e:MouseEvent):void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,leftEnterFrame);
		}
		private function leftEnterFrame(e:Event):void
		{
			if(MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA)!=null)
			{
				MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[0,-cameraRotateSpeed]);
			}
		}
		//右风车
		private function cameraRightMouseDownEvent(e:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME,rightEnterFrame);
		}
		private function cameraRightMouseUpEvent(e:MouseEvent):void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,rightEnterFrame);
		}
		private function rightEnterFrame(e:Event):void
		{
			if(MainSystem.getInstance().runAPIDirectDirectly(ScriptName.GET_CAMERA)!=null)
			{
				MainSystem.getInstance().runAPIDirectDirectly(ScriptName.SET_GOTO_ROTATION,[0,cameraRotateSpeed]);
			}
		}
	}
}
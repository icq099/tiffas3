package lxfa.mainMenuTop
{
	import caurina.transitions.Tweener;
	
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.menu.popumenu.view.PopupMenuManager;
	
	import mx.core.Application;
	
	import yzhkof.Toolyzhkof;
	
	public class MainMenuTop extends MainMenu
	{
		private var top:MainMenuTopSwc;
		private var hasBackGround:Boolean=true;
		private var popupMenuManager:PopupMenuManager;
		private var head:MainMenuHead=new MainMenuHead();
		public function MainMenuTop()
		{
			top=new MainMenuTopSwc();
			this.addChild(top);
			top.alpha=0;
			Tweener.addTween(top,{alpha:1,time:3});
			initLaba();
			init();
		}
		private function init():void
		{
			popupMenuManager=new PopupMenuManager();
			popupMenuManager.init(top.lvsejiayuan,top.lvsejiayuan.name,0);
			popupMenuManager.init(top.lansemengxiang,top.lansemengxiang.name,1);
			popupMenuManager.init(top.meiguantianxia,top.meiguantianxia.name,2);
			popupMenuManager.init(top.jinxiuhuazhang,top.jinxiuhuazhang.name,3);
			popupMenuManager.init(top.shengshihexie,top.shengshihexie.name,4);
			popupMenuManager.init(top.zonghengsihai,top.zonghengsihai.name,5);
			popupMenuManager.init(top.yangmengbagui,top.yangmengbagui.name,6);
			top.stop();
			Application.application.addChild(Toolyzhkof.mcToUI(head));
			head.x=94;
			head.y=4;
			head.buttonMode=true;
			head.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				if(top.currentFrame==1 || top.currentFrame==2)
				{
					top.play();
					top.addFrameScript(top.totalFrames-1,function():void{
						top.stop();
					});
				}
				if(top.currentFrame==top.totalFrames)
				{
					top.addEventListener(Event.ENTER_FRAME,enter);
					top.addFrameScript(1,function():void{
						top.stop();
						MemoryRecovery.getInstance().gcFun(top,Event.ENTER_FRAME,enter);
					});
				}
			});
		}
		private function enter(e:Event):void
		{
			top.prevFrame();
		}
		private function lvsejiayuanClick():void
		{
			customGoto3DScene(0);
		}
		private function lansemengxiangClick():void
		{
			customGoto3DScene(1);
		}
		private function meiguantianxiaClick():void
		{
			customGoto3DScene(2);
		}
		private function jinxiuhuazhangClick():void
		{
			customGoto3DScene(3);
		}
		private function shengshihexieClick():void
		{
			customGoto3DScene(4);
		}
		private function zonghengsihaiClick():void
		{
			customGoto2DScene(5,"ZongHengSiHaiModule");
		}
		private function yangmengbaguiClick():void
		{
			customGoto2DScene(6,"YangMengBaGuiModule");
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
		public function dispose():void
		{
			top.parent.removeChild(top);
			top=null;
		}
	}
}
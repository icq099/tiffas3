package plugins.lxfa.mainMenuTop
{
	import caurina.transitions.Tweener;
	
	import core.manager.musicManager.BackGroundMusicManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import memory.MemoryRecovery;
	import mx.core.Application;
	
	import util.menu.popumenu.view.PopupMenuManager;
	
	import view.fl2mx.Fl2Mx;
	
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
			top.gotoAndStop(top.totalFrames);
			Application.application.addChild(Fl2Mx.fl2Mx(head));
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
				BackGroundMusicManager.getInstance().hasBackGroundMusic=false;
			}
			else
			{
				top.laba.gotoAndStop(1);
				hasBackGround=true;
				BackGroundMusicManager.getInstance().hasBackGroundMusic=true;
			}
		}
		public function dispose():void
		{
			top.parent.removeChild(top);
			top=null;
		}
	}
}
package lxfa.mainMenuTop
{
	import caurina.transitions.Tweener;
	
	import communication.MainSystem;
	
	import flash.events.MouseEvent;
	
	import lxfa.utils.CollisionManager;
	
	public class MainMenuTop extends MainMenu
	{
		private var top:MainMenuTopSwc;
		private var hasBackGround:Boolean=true;
		public function MainMenuTop()
		{
			top=new MainMenuTopSwc();
			this.addChild(top);
			top.alpha=0;
			Tweener.addTween(top,{alpha:1,time:3});
			initLaba();
			initCollision();
		}
		private function initCollision():void
		{
			top.addFrameScript(10,addAreas);
			top.addFrameScript(94,removeAreas);
		}
		private function addAreas():void
		{
			var lvsejiayuanArea:Array=[[[221,31],[299,47]]];
			CollisionManager.getInstance().addCollision(lvsejiayuanArea,lvsejiayuanClick,"lvsejiayuan");
			var lansemengxiangArea:Array=[[[312,31],[390,47]]];
			CollisionManager.getInstance().addCollision(lansemengxiangArea,lansemengxiangClick,"lansemengxiang");
			var meiguantianxiaArea:Array=[[[406,31],[485,47]]];
			CollisionManager.getInstance().addCollision(meiguantianxiaArea,meiguantianxiaClick,"meiguantianxia");
			var jinxiuhuazhangArea:Array=[[[497,31],[575,47]]];
			CollisionManager.getInstance().addCollision(jinxiuhuazhangArea,jinxiuhuazhangClick,"jinxiuhuazhang");
			var shengshihexieArea:Array=[[[592,31],[672,47]]];
			CollisionManager.getInstance().addCollision(shengshihexieArea,shengshihexieClick,"shengshihexie");
			var zonghengsihaiArea:Array=[[[685,31],[771,47]]];
			CollisionManager.getInstance().addCollision(zonghengsihaiArea,zonghengsihaiClick,"zonghengsihai");
			var yangmengbaguiArea:Array=[[[787,31],[866,47]]];
			CollisionManager.getInstance().addCollision(yangmengbaguiArea,yangmengbaguiClick,"yangmengbagui");
		}
		private function removeAreas():void
		{
			CollisionManager.getInstance().removeCollision("lvsejiayuan");
			CollisionManager.getInstance().removeCollision("lansemengxiang");
			CollisionManager.getInstance().removeCollision("meiguantianxia");
			CollisionManager.getInstance().removeCollision("jinxiuhuazhang");
			CollisionManager.getInstance().removeCollision("shengshihexie");
			CollisionManager.getInstance().removeCollision("zonghengsihai");
			CollisionManager.getInstance().removeCollision("yangmengbagui");
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
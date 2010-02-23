package lxfa.index.view
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	
	import mx.core.UIComponent;
	
	public class Index extends UIComponent
	{
		private var indexSwc:IndexSwc;
		private var flowerFlvSwf:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function Index()
		{
			initIndexSwc();
			initFlowerFlvSwf();
			initDownloadProgress();
		}
		private function initIndexSwc():void
		{
			indexSwc=new IndexSwc();
			indexSwc.btn_skip.visible=false;
			indexSwc.btn_enter.mouseEnabled=false;
			indexSwc.btn_enter.addEventListener(MouseEvent.CLICK,on_btn_enter_click);
			indexSwc.btn_skip.addEventListener(MouseEvent.CLICK,on_btn_skip_click);
			this.addChild(indexSwc);
		}
		private function on_btn_enter_click(e:MouseEvent):void
		{
			this.removeChild(indexSwc);
			this.removeChild(flowerFlvSwf);
			flowerFlvSwf=null;
			this.addChild(flvPlayer);
			flvPlayer.resume();
			indexSwc.btn_skip.visible=true;
			this.addChild(indexSwc.btn_skip);
		}
		private function on_btn_skip_click(e:MouseEvent):void
		{
			MainSystem.getInstance().removePluginById("IndexModule");
			MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
			MainSystem.getInstance().gotoScene(0);
		}
		private function initFlowerFlvSwf():void
		{
			flowerFlvSwf=new SwfPlayer("swf/flowerfly.swf",900,480);
			flowerFlvSwf.x=-200;
			flowerFlvSwf.y=-100;
			flowerFlvSwf.addEventListener(Event.COMPLETE,completeHandler);//SWF文件
		}
		private function initDownloadProgress():void
		{
			flvPlayer=new FLVPlayer();
			flvPlayer.addEventListener(ProgressEvent.PROGRESS,downLoadprogressHandler);
			flvPlayer.addEventListener(Event.COMPLETE,downLoadcompleteHandler);
		}
		private function downLoadprogressHandler(e:ProgressEvent):void
		{
			indexSwc.btn_enter.mouseEnabled=true;
		}
		private function downLoadcompleteHandler(e:Event):void
		{
			
		}
		private function completeHandler(e:Event):void
		{
			this.addChild(flowerFlvSwf);
		}
		public function dispose():void
		{
			flvPlayer.dispose();
			flvPlayer=null;
		}
	}
}
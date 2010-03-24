package lxfa.index.view
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextFieldAutoSize;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.UIComponent;
	
	public class IndexBase extends UIComponent
	{
		private var indexSwc:IndexSwc;
		private var flowerFlvSwf:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		public function IndexBase()
		{
			initIndexSwc();
			initFlowerFlvSwf();
			initDownloadProgress();
		}
		private function initIndexSwc():void
		{
			indexSwc=new IndexSwc();
			indexSwc.btn_enter.mouseEnabled=false;
			indexSwc.btn_enter.addEventListener(MouseEvent.CLICK,on_btn_enter_click);
			indexSwc.progressText.autoSize=TextFieldAutoSize.LEFT;
			indexSwc.progressText.mouseEnabled=false;
			indexSwc.btn_skip.visible=false;
			this.addChild(indexSwc);
		}
		private function on_btn_enter_click(e:MouseEvent):void
		{
			indexSwc.mouseEnabled=false;
			this.addChild(flvPlayer);
			this.removeChild(indexSwc);
			MemoryRecovery.getInstance().gcFun(flowerFlvSwf,Event.COMPLETE,completeHandler);//SWF文件
			MemoryRecovery.getInstance().gcObj(flowerFlvSwf);
			flvPlayer.resume();
			flvPlayer.addEventListener(Event.CLOSE,on_flvPlayer_close);
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_NET_STATUS_change);
		}
		//播放完毕
		private function on_NET_STATUS_change(e:NetStatusEvent):void
		{
			MainSystem.getInstance().showPluginById("No3Module");
		}
		//跳过第二个电影
		private function on_flvPlayer_close(e:Event):void
		{
			MainSystem.getInstance().showPluginById("No3Module");
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
			flvPlayer=new FLVPlayer("video/index/index.flv",900,480);
			flvPlayer.addEventListener(ProgressEvent.PROGRESS,downLoadprogressHandler);
			flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE,downLoadcompleteHandler);
		}
		private function downLoadprogressHandler(e:ProgressEvent):void
		{
			indexSwc.progressText.text=String(int((e.bytesLoaded/e.bytesTotal)*100));
		}
		private function downLoadcompleteHandler(e:FLVPlayerEvent):void
		{
			indexSwc.btn_enter.mouseEnabled=true;
		}
		private function completeHandler(e:Event):void
		{
			this.addChild(flowerFlvSwf);
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(indexSwc.btn_enter,MouseEvent.CLICK,on_btn_enter_click);
			MemoryRecovery.getInstance().gcObj(indexSwc.btn_enter);
			MemoryRecovery.getInstance().gcObj(indexSwc.btn_skip);
			MemoryRecovery.getInstance().gcObj(indexSwc.progressText);
			MemoryRecovery.getInstance().gcFun(flvPlayer,ProgressEvent.PROGRESS,downLoadprogressHandler);
			MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS,on_NET_STATUS_change);
			flvPlayer.dispose();
			flvPlayer.parent.removeChild(flvPlayer);
			flvPlayer=null;
		}
	}
}
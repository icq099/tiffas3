package lxfa.index.view
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextFieldAutoSize;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.view.player.FLVPlayer;
	
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
			this.removeChild(indexSwc);
			this.removeChild(flowerFlvSwf);
			this.addChild(flvPlayer);
			flowerFlvSwf=null;
			flvPlayer.resume();
			flvPlayer.addEventListener(Event.CLOSE,on_flvPlayer_close);
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_NET_STATUS_change);
		}
		//播放完毕
		private function on_NET_STATUS_change(e:NetStatusEvent):void
		{
			MainSystem.getInstance().showPluginById("No3Module");
			MainSystem.getInstance().removePluginById("IndexModule");
		}
		//跳过第二个电影
		private function on_flvPlayer_close(e:Event):void
		{
			MainSystem.getInstance().removePluginById("IndexModule");
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
			flvPlayer.addEventListener(Event.COMPLETE,downLoadcompleteHandler);
		}
		private function downLoadprogressHandler(e:ProgressEvent):void
		{
			indexSwc.progressText.text=String(int((e.bytesLoaded/e.bytesTotal)*100));
		}
		private function downLoadcompleteHandler(e:Event):void
		{
			indexSwc.btn_enter.mouseEnabled=true;
		}
		private function completeHandler(e:Event):void
		{
			this.addChild(flowerFlvSwf);
		}
		public function dispose():void
		{
			flvPlayer.dispose();
			flvPlayer.parent.removeChild(flvPlayer);
			flvPlayer=null;
		}
	}
}
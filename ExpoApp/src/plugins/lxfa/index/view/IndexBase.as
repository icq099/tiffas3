package plugins.lxfa.index.view
{
	import core.manager.pluginManager.PluginManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextFieldAutoSize;
	
	import memory.MemoryRecovery;
	
	import mx.core.UIComponent;
	import util.view.player.FLVPlayer;
	import util.view.player.event.FLVPlayerEvent;
	
	import view.player.SwfPlayer;
	
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
			indexSwc.btn_enter.visible=false;
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
			if(flowerFlvSwf.hasEventListener(Event.COMPLETE))
			{
				flowerFlvSwf.removeEventListener(Event.COMPLETE,completeHandler)
			}
			if(flowerFlvSwf.parent!=null)
			{
				flowerFlvSwf.parent.removeChild(flowerFlvSwf);
			}
			flowerFlvSwf.dispose();
			flowerFlvSwf=null;
			flvPlayer.resume();
			flvPlayer.addEventListener(Event.CLOSE,on_flvPlayer_close);
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_NET_STATUS_change);
		}
		//播放完毕
		private function on_NET_STATUS_change(e:NetStatusEvent):void
		{
			PluginManager.getInstance().showPluginById("No3Module");
		}
		//跳过第二个电影
		private function on_flvPlayer_close(e:Event):void
		{
			PluginManager.getInstance().showPluginById("No3Module");
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
			flvPlayer=new FLVPlayer("http://flv.pavilion.expo.cn/p5006/flv/scene_scene/index.flv",900,480);
			flvPlayer.addEventListener(ProgressEvent.PROGRESS,downLoadprogressHandler);
			flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE,downLoadcompleteHandler);
		}
		private function downLoadprogressHandler(e:ProgressEvent):void
		{
			indexSwc.progressText.text=String(int((e.bytesLoaded/e.bytesTotal)*100));
		}
		private function downLoadcompleteHandler(e:FLVPlayerEvent):void
		{
			indexSwc.progressText.text="100";
			indexSwc.btn_enter.visible=true;
		}
		private function completeHandler(e:Event):void
		{
			this.addChild(flowerFlvSwf);
		}
		public function dispose():void
		{
			if(indexSwc.btn_enter.hasEventListener(MouseEvent.CLICK))
			{
				indexSwc.btn_enter.removeEventListener(MouseEvent.CLICK,on_btn_enter_click);
			}
			if(indexSwc.btn_enter!=null)
			{
				if(indexSwc.btn_enter.parent!=null)
				{
					indexSwc.btn_enter.parent.removeChild(indexSwc.btn_enter);
				}
				indexSwc.btn_enter=null;
			}
			if(indexSwc.btn_skip!=null)
			{
				if(indexSwc.btn_skip.parent!=null)
				{
					indexSwc.btn_skip.parent.removeChild(indexSwc.btn_skip);
				}
				indexSwc.btn_skip=null;
			}
			if(indexSwc.progressText!=null)
			{
				if(indexSwc.progressText.parent!=null)
				{
					indexSwc.progressText.parent.removeChild(indexSwc.progressText);
				}
				indexSwc.progressText=null;
			}
			if(indexSwc!=null)
			{
				if(indexSwc.parent!=null)
				{
					indexSwc.parent.removeChild(indexSwc);
				}
				indexSwc=null;
			}
			MemoryRecovery.getInstance().gcFun(flvPlayer,ProgressEvent.PROGRESS,downLoadprogressHandler);
			MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS,on_NET_STATUS_change);
			MemoryRecovery.getInstance().gcFun(flvPlayer,FLVPlayerEvent.COMPLETE,downLoadcompleteHandler);
			flvPlayer.dispose();
			flvPlayer.parent.removeChild(flvPlayer);
			flvPlayer=null;
		}
	}
}
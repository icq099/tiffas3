package lxfa.shanshuishihua.view
{
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class NormalWindow extends UIComponent
	{
		private var dp:DetailPreview;
		private var flvPlayer:FLVPlayer;
		public function NormalWindow()
		{
			initDp();
			this.addChild(dp);
			dp.Btn_Close.addEventListener(MouseEvent.CLICK,onClick);
			dp.btn_360.addEventListener(MouseEvent.CLICK,on360Click);
			dp.btn_video.addEventListener(MouseEvent.CLICK,onVideoClick);
			dp.btn_music.addEventListener(MouseEvent.CLICK,onMusicClick);
		}
		private function initDp():void
		{
			dp=new DetailPreview();
			dp.panel2.visible=false;
			dp.panel3.visible=false;
		}
		private function onClick(e:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
			dp=null;
			if(flvPlayer!=null)
			{
				flvPlayer.close();
				flvPlayer=null;
			}
		}
		public function load(url:String):void{
			flvPlayer=new FLVPlayer(url,320,240);
		    dp.panel2.addChild(flvPlayer);
		    var object360Viewer:Object360Viewer=new Object360Viewer();
		    object360Viewer.load("img/shanshuishihua/360/坭兴陶2-",3,24);
		    dp.panel1.addChild(object360Viewer);
		}
		//下面实现分页栏
		//全景360演示的点击事件
		private function on360Click(e:MouseEvent):void
		{
			dp.panel1.visible=true;
			dp.panel2.visible=false;
			dp.panel3.visible=false;
			flvPlayer.pause();//暂停播放
		}
		//视频按钮的点击事件
		private function onVideoClick(e:MouseEvent):void
		{
			dp.panel1.visible=false;
			dp.panel2.visible=true;
			dp.panel3.visible=false;
			flvPlayer.play();
		}
		//音频按钮的点击事件
		private function onMusicClick(e:MouseEvent):void
		{
			dp.panel1.visible=false;
			dp.panel2.visible=false;
			dp.panel3.visible=true;
			flvPlayer.pause();//暂停播放
		}
	}
}
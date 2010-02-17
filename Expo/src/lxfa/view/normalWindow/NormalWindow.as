package lxfa.view.normalWindow
{
	/************************************************************
	 * 标准窗的内容包括：
	 * 360体验窗口，视频窗口，音乐播放，文本（包括自定义滚动条）
	 * 标准窗加载顺序：
	 * 当标准窗被加载进主容器里面的时候，开始加载360体验窗口，加载完360体验窗口时，就开始加载视频窗口和音乐播放，文本加载就随意
	 */
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.shanshuishihua.view.CustomScrollBar;
	
	import mx.core.UIComponent;
	
	import view.Object360Viewer;
	import view.player.FlvPlayer;
	public class NormalWindow extends UIComponent
	{
		private var dp:NormalWindowSwc;//标准窗的SWC
		private var flvPlayer:FlvPlayer;//flv播放器
		private var viewer360:Object360Viewer;//图片360体验窗口
		private var customScrollBar:CustomScrollBar;//自定义滚动条
		private var sound:Mp3Player;//mp3播放器
		private var pictureUrl:String;//图片路径
		private var videoUrl:String;//视频路径
		private var musicUrl:String;//音频路径
		private var text:String;//文本
		public function NormalWindow(pictureUrl:String=null,videoUrl:String=null,musicUrl:String=null,text:String=null)
		{
			initDp();
            initUrls(pictureUrl,videoUrl,musicUrl,text);
			initController();
			initScrollBar();
		}
		//加载所有的链接和文本
		private function initUrls(pictureUrl:String=null,videoUrl:String=null,musicUrl:String=null,text:String=null):void
		{
			this.pictureUrl=pictureUrl;
			this.videoUrl=videoUrl;
			this.musicUrl=musicUrl;
			this.text=text;
		}
		//加载自定义滚动条
		private function initScrollBar():void
		{
			customScrollBar=new CustomScrollBar(this.dp,this.text);
			this.addChild(customScrollBar);
		}
		//加载监听器
		private function initController():void
		{
			dp.btn_360.addEventListener(MouseEvent.CLICK,on360Click);
			dp.btn_video.addEventListener(MouseEvent.CLICK,onVideoClick);
			dp.btn_music.addEventListener(MouseEvent.CLICK,onMusicClick);
			this.addEventListener(Event.ADDED,onADDED);
		}
		//如果标准窗被加载进了主容器中，才加载360体验窗
		private function onADDED(e:Event):void
		{
			this.removeEventListener(Event.ADDED,onADDED);
				initViewer360();
		}
		//加载MP3
		private function initMp3Player():void
		{
			if(this.musicUrl!="")
			{
				sound=new Mp3Player(musicUrl);
				this.dp.panel3.addChild(sound);
			}
		}
		//加载标准窗的背景
		private function initDp():void
		{
			dp=new NormalWindowSwc();
			dp.panel1.visible=true;
			dp.panel2.visible=false;
			dp.panel3.visible=false;
			this.addChild(dp);
		}
		//关闭按钮的点击事件
		private function onClick(e:MouseEvent):void
		{
			close();
		}
		//加载视频播放
		private function initFlvPlayer():void
		{
			if(videoUrl!="")
			{
				flvPlayer=new FlvPlayer();
				flvPlayer.loadFlv(videoUrl);
				flvPlayer.x=1.5;
				flvPlayer.y=1.5;
			    dp.panel2.addChild(flvPlayer);	
			}
		}
		//添加360体验面板
		private function initViewer360():void
		{
			viewer360=new Object360Viewer();
		    viewer360.load(pictureUrl,3,24);
		    var scale:Number=new Number(dp.panel1.width/640);
		    viewer360.scaleX=viewer360.scaleY=scale;
		    viewer360.addEventListener(Event.COMPLETE,onViewer360Complete);
		    viewer360.addEventListener(Event.CLEAR,onView360Clear);
		    if(pictureUrl=="")//如果没有360图片。就抛出CLEAR事件，只是作为区别，并不是真正的CLEAR
		    {
		    	viewer360.dispatchEvent(new Event(Event.CLEAR));
		    }
		}
		//没有360图片的情况
		private function onView360Clear(e:Event):void
		{
			viewer360.removeEventListener(Event.CLEAR,onView360Clear);//清除事件
			dp.Btn_Close.addEventListener(MouseEvent.CLICK,onClick);
			initFlvPlayer();
			initMp3Player();
		}
		//360图片加载完毕
		private var isLoaded:Boolean;
		private function onViewer360Complete(e:Event):void
		{
			if(!isLoaded)
			{
				dp.panel1.addChild(viewer360);
				dp.Btn_Close.addEventListener(MouseEvent.CLICK,onClick);//360图片加载完之后才能添加关闭事件
				isLoaded=true;
				initFlvPlayer();
				initMp3Player();
			}
		}
		//下面实现分页栏
		//全景360演示的点击事件
		private function on360Click(e:MouseEvent):void
		{
			dp.panel1.visible=true;
			dp.panel2.visible=false;
			dp.panel3.visible=false;
			if(flvPlayer!=null)
			{
//				flvPlayer.pause();//暂停播放
			}
		}
		//视频按钮的点击事件
		private function onVideoClick(e:MouseEvent):void
		{
			dp.panel1.visible=false;
			dp.panel2.visible=true;
			dp.panel3.visible=false;
			if(flvPlayer!=null)
			{
//				flvPlayer.play();//暂停播放
			}
			if(sound!=null)
			{
				sound.stop();
			}
		}
		//音频按钮的点击事件
		private function onMusicClick(e:MouseEvent):void
		{
			dp.panel1.visible=false;
			dp.panel2.visible=false;
			dp.panel3.visible=true;
			if(flvPlayer!=null)
			{
//				flvPlayer.pause();//暂停播放
			}
			if(sound!=null)
			{
				sound.play();
			}
		}
		//标准窗关闭，清除内存
		public function close():void
		{
			if(viewer360!=null)
			{
				viewer360=null;
			}
			if(flvPlayer!=null)
			{
				flvPlayer.stopAll();
				dp.panel2.removeChild(flvPlayer);
				flvPlayer=null;
			}
			dp=null;
			if(sound!=null)
			{
				sound.close();
			}
			this.dispatchEvent(new Event(Event.CLOSE));
			this.parent.removeChild(this);
		}
	}
}
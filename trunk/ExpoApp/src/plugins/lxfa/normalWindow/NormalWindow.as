package plugins.lxfa.normalWindow
{
	/************************************************************
	 * 标准窗的内容包括：
	 * 360体验窗口，视频窗口，音乐播放，文本（包括自定义滚动条）
	 * 标准窗加载顺序：
	 * 当标准窗被加载进主容器里面的时候，开始加载360体验窗口，加载完360体验窗口时，就开始加载视频窗口和音乐播放，文本加载就随意
	 */
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import memory.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	import plugins.yzhkof.view.Object360Viewer;
	import plugins.yzhkof.view.player.FlvPlayer;
	
	import view.player.PicturePlayer;
	public class NormalWindow extends UIComponent
	{
		private var dp:NormalWindowSwc;             //标准窗的SWC
		private var flvPlayer:FlvPlayer;            //flv播放器
		private var viewer360:Object360Viewer;      //图片360体验窗口
		private var customScrollBar:CustomScrollBar;//自定义滚动条
		private var picturePlayer:PicturePlayer;                //mp3播放器
		private var pictureUrl:String;              //图片路径
		private var videoUrl:String;                //视频路径
		private var pictureUrls:Array;              //音频路径
		private var text:String;//文本
		public function NormalWindow(pictureUrl:String=null,videoUrl:String=null,pictureUrls:Array=null,text:String=null,picture360Name:String=null,videoName:String=null,pictureName:String=null)
		{
			initDp(pictureUrl,videoUrl,pictureUrls);
            initUrls(pictureUrl,videoUrl,pictureUrls,text);
            initTextsAndButton(picture360Name,videoName,pictureName);
            initUI(pictureUrl,videoUrl,pictureUrls);
			initController();
			initScrollBar();
		}
		//加载所有的链接和文本
		private function initUrls(pictureUrl:String=null,videoUrl:String=null,pictureUrls:Array=null,text:String=null):void
		{
			this.pictureUrl=pictureUrl;
			this.videoUrl=videoUrl;
			this.pictureUrls=pictureUrls;
			this.text=text;
		}
		//根据名字，调整所有文本与按钮的位置，大小
		private function initTextsAndButton(picture360Name:String,videoName:String,pictureName:String):void
		{
			//调整文本的名字
			if(picture360Name!=null && picture360Name!="")
			{
				dp.btn_360_text.text=picture360Name;
			}
			if(videoName!=null && videoName!="")
			{
				dp.btn_video_text.text=videoName;
			}
			if(pictureName!=null && pictureName!="")
			{
				dp.btn_picture_text.text=pictureName;
			}
			//全部自动调整字体大小
			dp.btn_video_text.autoSize=TextFieldAutoSize.CENTER;
			dp.btn_360_text.autoSize=TextFieldAutoSize.CENTER;
			dp.btn_picture_text.autoSize=TextFieldAutoSize.CENTER;
			var add:Number=6;//按钮比所对应的字大6像素
			//根据字体大小，调整按钮的大小
			dp.btn_360.width=dp.btn_360_text.width+add;//6,按钮总比字体大点点
			dp.btn_video.width=dp.btn_video_text.width+add;//6,按钮总比字体大点点
			dp.btn_picture.width=dp.btn_picture_text.width+add;//6,按钮总比字体大点点
			if(dp.btn_360.width<60){dp.btn_360.width=60;}
			if(dp.btn_picture.width<60){dp.btn_picture.width=60;}
			if(dp.btn_video.width<60){dp.btn_video.width=60;}
			//调整按钮的位置
			dp.btn_video.x=dp.btn_360.x+dp.btn_360.width+1;
			dp.btn_picture.x=dp.btn_video.x+dp.btn_video.width+1;
			//调整字体的位置,字体的位置是根据所对应的按钮的位置调整的
			dp.btn_360_text.x=dp.btn_360.x+(dp.btn_360.width-dp.btn_360_text.width)/2;
			dp.btn_video_text.x=dp.btn_video.x+(dp.btn_video.width-dp.btn_video_text.width)/2;
			dp.btn_picture_text.x=dp.btn_picture.x+(dp.btn_picture.width-dp.btn_picture_text.width)/2;
		}
		//根据链接调整布局
		private function initUI(pictureUrl:String=null,videoUrl:String=null,pictureUrls:Array=null):void
		{
			dp.btn_video_text.mouseEnabled=false;
			dp.btn_360_text.mouseEnabled=false;
			dp.btn_picture_text.mouseEnabled=false;
			//如果没有360图片。那么“视频”和“音频”按钮向左移动,并删除"360图片"按钮
			if(pictureUrl=="" || pictureUrl==null)
			{
				dp.btn_video.x-=dp.btn_360.width;
				dp.btn_video_text.x-=dp.btn_360.width;
				dp.btn_picture.x-=dp.btn_360.width;
				dp.btn_picture_text.x-=dp.btn_360.width;
				dp.removeChild(dp.btn_360_text);
				dp.removeChild(dp.btn_360);
				dp.removeChild(dp.panel1);
			}
			//如果没有视频，那么“音频”按钮向左移动并删除“视频”按钮
			if(videoUrl=="" || videoUrl==null)
			{
				dp.btn_picture.x-=dp.btn_video.width;
				dp.btn_picture_text.x-=dp.btn_video.width;
				dp.removeChild(dp.btn_video_text);
				dp.removeChild(dp.btn_video);
				dp.removeChild(dp.panel2);
			}
			//如果没有音频，那么就删除音频按钮
			if((pictureUrls!=null&&pictureUrls.length==0) || pictureUrls==null)
			{
				dp.removeChild(dp.btn_picture_text);
				dp.removeChild(dp.btn_picture);
				dp.removeChild(dp.panel3);
			}
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
			dp.btn_picture.addEventListener(MouseEvent.CLICK,onMusicClick);
			dp.Btn_Close.addEventListener(MouseEvent.CLICK,onClick);
			this.addEventListener(Event.ADDED,onADDED);
		}
		//如果标准窗被加载进了主容器中，才加载360体验窗
		private function onADDED(e:Event):void
		{
			this.removeEventListener(Event.ADDED,onADDED);
			initViewer360();
		}
		//加载标准窗的背景
		private function initDp(pictureUrl:String=null,videoUrl:String=null,pictureUrls:Array=null):void
		{
			dp=new NormalWindowSwc();
			this.addChild(dp);
			if(!(pictureUrl=="" || pictureUrl==null))
			{
				dp.panel1.visible=true;
				dp.panel2.visible=false;
				dp.panel3.visible=false;
				return;
			}
			if(!(videoUrl=="" || videoUrl==null))
			{
				dp.panel1.visible=false;
				dp.panel2.visible=true;
				dp.panel3.visible=false;
				return;
			}
			if(!((pictureUrls!=null && pictureUrls.length==0)|| pictureUrls==null))
			{
				dp.panel1.visible=false;
				dp.panel2.visible=false;
				dp.panel3.visible=true;
				return;
			}
		}
		//*按钮的点击事件
		private function onClick(e:MouseEvent):void
		{
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVE_NORMAL_WINDOW,[]);
		}
		//加载视频播放
		private function initFlvPlayer():void
		{
			if(videoUrl!="" || videoUrl!=null)
			{
				flvPlayer=new FlvPlayer();
				flvPlayer.loadFlv(videoUrl);
				flvPlayer.x=1.5;
				flvPlayer.y=1.5;
				flvPlayer.controlerWidth=381;
				flvPlayer.setTime_TextVisible(false);
			    dp.panel2.addChild(flvPlayer);	
			}
		}
		//添加360体验面板
		private function initViewer360():void
		{
			viewer360=new Object360Viewer();
		    viewer360.load(pictureUrl,3,8);
		    var scale:Number=new Number(dp.panel1.width/640);
		    viewer360.scaleX=0.64;
		    viewer360.scaleY=0.9;
		    viewer360.addEventListener(Event.COMPLETE,onViewer360Complete);
		    viewer360.addEventListener(Event.ID3,onView360Clear);
		    if(pictureUrl=="" || pictureUrl==null)//如果没有360图片。就抛出CLEAR事件，只是作为区别，并不是真正的CLEAR
		    {
		    	viewer360.dispatchEvent(new Event(Event.ID3));
		    }
		}
		//没有360图片的情况
		private function onView360Clear(e:Event):void
		{
			viewer360.removeEventListener(Event.ID3,onView360Clear);//清除事件
			dp.Btn_Close.addEventListener(MouseEvent.CLICK,onClick);
			initFlvPlayer();
			initPicturePlayer();
		}
		//图片浏览器
		private function initPicturePlayer():void
		{
			picturePlayer=new PicturePlayer(this.pictureUrls,dp.panel3);
			picturePlayer.x=25;
			picturePlayer.y=230;
			dp.panel3.addChild(picturePlayer);
		}
		//360图片加载完毕
		private var isLoaded:Boolean;
		private function onViewer360Complete(e:Event):void
		{
			if(!isLoaded && viewer360!=null)
			{
				dp.panel1.addChild(viewer360);
				isLoaded=true;
				initFlvPlayer();
				initPicturePlayer();
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
		}
		//音频按钮的点击事件
		private function onMusicClick(e:MouseEvent):void
		{
			dp.panel1.visible=false;
			dp.panel2.visible=false;
			dp.panel3.visible=true;
		}
		//标准窗关闭，清除内存
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ADDED,onADDED);
			MemoryRecovery.getInstance().gcFun(dp.btn_360,MouseEvent.CLICK,on360Click);
			MemoryRecovery.getInstance().gcFun(dp.btn_video,MouseEvent.CLICK,onVideoClick);
			MemoryRecovery.getInstance().gcFun(dp.btn_picture,MouseEvent.CLICK,onMusicClick);
			MemoryRecovery.getInstance().gcFun(viewer360,Event.COMPLETE,onViewer360Complete);
			MemoryRecovery.getInstance().gcFun(viewer360,Event.ID3,onView360Clear);
			MemoryRecovery.getInstance().gcFun(dp.Btn_Close,MouseEvent.CLICK,onClick);
			if(customScrollBar!=null)
			{
				if(customScrollBar.parent!=null)
				{
					customScrollBar.parent.removeChild(customScrollBar);
				}
				customScrollBar.dispose();
				customScrollBar=null;
			}
			if(viewer360!=null)
			{
				if(viewer360.parent!=null)
				{
					viewer360.parent.removeChild(viewer360);
				}
				viewer360=null;
			}
			if(flvPlayer!=null)
			{
				flvPlayer.stopAll();
				if(flvPlayer.parent!=null)
				{
					flvPlayer.parent.removeChild(flvPlayer);
				}
				flvPlayer=null;
			}
			if(picturePlayer!=null)
			{
				if(picturePlayer.parent!=null)
				{
					picturePlayer.parent.removeChild(picturePlayer);
				}
				picturePlayer.dispose();
				picturePlayer=null;
			}
			if(dp!=null)
			{
				if(dp.btn_360!=null)
				{
					if(dp.btn_360.parent!=null)
					{
						dp.btn_360.parent.removeChild(dp.btn_360);
					}
					dp.btn_360=null;
				}
				if(dp.btn_360_text!=null)
				{
					if(dp.btn_360_text.parent!=null)
					{
						dp.btn_360_text.parent.removeChild(dp.btn_360_text);
					}
					dp.btn_360_text=null;
				}
				if(dp.Btn_Close!=null)
				{
					if(dp.Btn_Close.parent!=null)
					{
						dp.Btn_Close.parent.removeChild(dp.Btn_Close);
					}
					dp.Btn_Close=null;
				}
				if(dp.btn_picture!=null)
				{
					if(dp.btn_picture.parent!=null)
					{
						dp.btn_picture.parent.removeChild(dp.btn_picture);
					}
					dp.btn_picture=null;
				}
				if(dp.btn_picture_text!=null)
				{
					if(dp.btn_picture_text.parent!=null)
					{
						dp.btn_picture_text.parent.removeChild(dp.btn_picture_text);
					}
					dp.btn_picture_text=null;
				}
				if(dp.btn_video!=null)
				{
					if(dp.btn_video.parent!=null)
					{
						dp.btn_video.parent.removeChild(dp.btn_video);
					}
					dp.btn_video=null;
				}
				if(dp.btn_video_text!=null)
				{
					if(dp.btn_video_text.parent!=null)
					{
						dp.btn_video_text.parent.removeChild(dp.btn_video_text);
					}
					dp.btn_video_text=null;
				}
				if(dp.center!=null)
				{
					if(dp.center.parent!=null)
					{
						dp.center.parent.removeChild(dp.center);
					}
					dp.center=null;
				}
				if(dp.panel1!=null)
				{
					if(dp.panel1.parent!=null)
					{
						dp.panel1.parent.removeChild(dp.panel1);
					}
					dp.panel1=null;
				}
				if(dp.panel2!=null)
				{
					if(dp.panel2.parent!=null)
					{
						dp.panel2.parent.removeChild(dp.panel2);
					}
					dp.panel2=null;
				}
				if(dp.panel3!=null)
				{
					if(dp.panel3.parent!=null)
					{
						dp.panel3.parent.removeChild(dp.panel3);
					}
					dp.panel3=null;
				}
				dp.stop();
				if(dp.parent!=null)
				{
					dp.parent.removeChild(dp);
				}
				dp=null;
			}
			pictureUrl=null;
			videoUrl=null;
			pictureUrls=null;
			text=null;
		}
	}
}
package plugins.lxfa.gehaiqingyun.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import plugins.lxfa.gehaiqingyun.model.GeHaiQingYunModel;
	import plugins.yzhkof.view.player.FlvPlayer;
	
	
	public class PlayListCtr
	{
		private var geHaiQingYunModel:GeHaiQingYunModel;//歌海情韵的数据库
		private var mediaList:Array;//音频（视频）的路径
		private var mediaNames:Array;//音频（视频）的名字
		private var geHaiQingYunSwc:GeHaiQingYunSwc;
		private var currentIndex:int=-999999;
		private var rubbishArray:Array=new Array();
		private var list:ListBg;
		public function PlayListCtr(geHaiQingYunSwc:GeHaiQingYunSwc,list:ListBg)
		{
			this.geHaiQingYunSwc=geHaiQingYunSwc;
			this.list=list;
			initGeHaiQingYunModel();
		}
		private function initGeHaiQingYunModel():void
		{
			geHaiQingYunModel=new GeHaiQingYunModel();
			onComplete(null);
		}
		private function onComplete(e:Event):void
		{
			mediaList=geHaiQingYunModel.getMediaList();
			mediaNames=geHaiQingYunModel.getMediaNames();
			initPlayList();
			playMedia(0);
		}
		private function initPlayList():void
		{
			var i:int;
			for(i=0;i<mediaList.length;i++)
			{
				var button:PlayListButton=new PlayListButton(i,mediaNames[i],this);
				button.y=i*19.8-list.height+10;
				rubbishArray.push(button);
				list.addChild(button);
			}
			list.addEventListener(Event.COMPLETE,function(e:Event):void{
				geHaiQingYunSwc.btn_play.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			},false,0,true);
		}
		public function playPre():void
		{
			if(flvPlayer!=null)//如果曾经播放过视频或音频
			{
				if(currentIndex-1>=0)
				{
					playMedia(--currentIndex);
				}
			}
		}
		public function playNext():void
		{
			if(flvPlayer!=null)//如果曾经播放过视频或音频
			{
				if(currentIndex+1<mediaList.length)
				{
					playMedia(++currentIndex);
				}
				else
				{
					playMedia(0);//最后一首了，就播放最前的那首
				}
			}
		}
		public function pause():void
		{
			if(flvPlayer!=null)
			{
				flvPlayer.pause();
			}
		}
		private var flvPlayer:FlvPlayer;
		public function playMedia(ID:int):void
		{
			currentIndex=ID;//当前播放的编号
			if(flvPlayer!=null)
			{
				geHaiQingYunSwc.videoViewer.removeChild(flvPlayer);
				flvPlayer.stopAll();
				flvPlayer=null;
			}
			if(ID!=-1)
			{
				var path:String=mediaList[ID];
				var finalChar:String=path.charAt(path.length-1);
				if(finalChar=="v" || finalChar=="V")//如果是要播放视频
				{
					flvPlayer=new FlvPlayer();
					flvPlayer.loadFlv(path);
					flvPlayer.width=geHaiQingYunSwc.videoViewer.width;
					flvPlayer.height=geHaiQingYunSwc.videoViewer.height;
					flvPlayer.setLeft_ButtonsVisible(false);
					flvPlayer.setTime_TextVisible(false);
					flvPlayer.resetControlerX();
					geHaiQingYunSwc.videoViewer.addChild(flvPlayer);
				}
				else//不然就是音频咯
				{
				}
				list.visible=false;
			}
		}
		public function play():void
		{
			if(flvPlayer!=null)
			{
				flvPlayer.play();
			}
		}
		public function dispose():void
		{
			geHaiQingYunSwc=null;
			geHaiQingYunModel.dispose();
			geHaiQingYunModel=null;
			mediaList=null;
			mediaNames=null;
			list=null;
			for each(var button:PlayListButton in rubbishArray)
			{
				if(button!=null)
				{
					if(button.parent!=null)
					{
						button.parent.removeChild(button);
					}
					button.dispose();
					button=null;
				}
			}
			if(flvPlayer!=null)
			{
				if(flvPlayer.parent!=null)
				{
					flvPlayer.parent.removeChild(flvPlayer);
				}
				flvPlayer.stopAll();
				flvPlayer=null;
			}
		}
	}
}
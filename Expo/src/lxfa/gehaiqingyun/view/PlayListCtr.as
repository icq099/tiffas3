package lxfa.gehaiqingyun.view
{
	import flash.events.Event;
	
	import lxfa.gehaiqingyun.model.GeHaiQingYunModel;
	import lxfa.utils.MemoryRecovery;
	import lxfa.utils.tool.Mp3PlayerBase;
	
	import view.player.FlvPlayer;
	
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
			geHaiQingYunModel=new GeHaiQingYunModel("xml/gehaiqingyun.xml");
			geHaiQingYunModel.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void
		{
			mediaList=geHaiQingYunModel.getMediaList();
			mediaNames=geHaiQingYunModel.getMediaNames();
			initPlayList();
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
		}
		public function playPre():void
		{
			if(flvPlayer!=null || mp3Player!=null)//如果曾经播放过视频或音频
			{
				if(currentIndex-1>=0)
				{
					playMedia(--currentIndex);
				}
			}
		}
		public function playNext():void
		{
			if(flvPlayer!=null || mp3Player!=null)//如果曾经播放过视频或音频
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
		private var flvPlayer:FlvPlayer;
		private var mp3Player:Mp3PlayerBase;
		public function playMedia(ID:int):void
		{
			currentIndex=ID;//当前播放的编号
			if(flvPlayer!=null)
			{
				geHaiQingYunSwc.videoViewer.removeChild(flvPlayer);
				flvPlayer.stopAll();
				flvPlayer=null;
			}
			if(mp3Player!=null)
			{
				mp3Player.close();
				mp3Player=null;
			}
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
				geHaiQingYunSwc.videoViewer.addChild(flvPlayer);
			}
			else//不然就是音频咯
			{
				mp3Player=new Mp3PlayerBase();
				mp3Player.loadMusic(path);
			}
			play();
			list.visible=false;
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
			MemoryRecovery.getInstance().gcFun(geHaiQingYunModel,Event.COMPLETE,onComplete);
			var i:int;
			for(i=0;i<rubbishArray.length;i++)
			{
				MemoryRecovery.getInstance().gcObj(rubbishArray[i],true);
			}
			if(flvPlayer!=null)
			{
				flvPlayer.stopAll();
			}
			if(mp3Player!=null)
			{
				mp3Player.close();
				mp3Player=null
			}
		}
	}
}
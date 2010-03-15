package lxfa.backGroundMusic
{
	import communication.MainSystem;
	
	import lxfa.view.event.Mp3PlayerEvent;
	import lxfa.view.player.Mp3Player;
	
	public class BackGroundBase
	{
		private var musics:Array=new Array;
		private const musicNum:int=3;
		private var index:int=0;
		public function BackGroundBase()
		{
			initMp3Players();
			MainSystem.getInstance().addAPI("stopSound",stop);
			MainSystem.getInstance().addAPI("playSound",play);
		}
		private function initMp3Players():void
		{
			for(var i:int=0;i<musicNum;i++)
			{
				var mp3:Mp3Player=new Mp3Player("sound/"+i+".mp3",true);
				musics.push(mp3);
				mp3.stop();
				mp3.addEventListener(Mp3PlayerEvent.COMPLETE,onComplete);
			}
			Mp3Player(musics[0]).play();
		}
		private function onComplete(e:Mp3PlayerEvent):void
		{
			++index;
			if(index==3)
			{
				index=0;
			}
			Mp3Player(musics[index]).replay();
		}
		public function stop():void
		{
			Mp3Player(musics[index]).stop();
		}
		public function play():void
		{
			Mp3Player(musics[index]).play();
		}
	}
}
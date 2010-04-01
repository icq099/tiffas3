package lxfa.utils.tool
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import lxfa.utils.MemoryRecovery;
	
	public class Mp3PlayerBase
	{
	   private var sound:Sound;
	   private var soundChannel:SoundChannel;
	   private var resumeTime:Number;
	   private var currentMusic:String
		public function Mp3PlayerBase()
		{
		}
		public function loadMusic(url:String):void{
		    if(url!="" && url!=null)
		    {
		    	currentMusic=url;
			    sound=new Sound();
				sound.load(new URLRequest(url));
				resumeTime = 0;
				soundChannel=sound.play();
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
		    }
		}
		public function reload():void
		{
			loadMusic(currentMusic);
		}
		private function soundFinished(e:Event):void{
			 MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
			 soundChannel=sound.play(0);
			 soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
		}
		
		public function soundStop():void{
			if(soundChannel!=null){
			   soundChannel.stop();
			}
		}
		
		public function close():void{
			
			soundStop();
			MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
		    soundChannel=null;
		    sound=null;
		}

	}
}
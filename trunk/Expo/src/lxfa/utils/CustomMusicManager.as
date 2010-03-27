package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	
	public class CustomMusicManager extends Sprite
	{
	   private static var instance:CustomMusicManager
	   private var sound:Sound;
	   private var soundChannel:SoundChannel;
	   private var resumeTime:Number;
	  
	   
		public function CustomMusicManager()
		{
		   if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("不能实例化");
			}
		}
		public static function getInstance():CustomMusicManager
		{
			if(instance==null) return new CustomMusicManager();
			return instance;
		}
		
		public function loadCustomMusic(url:String):void{
		    
		    sound=new Sound();
			sound.load(new URLRequest(url));
			resumeTime = 0;
			soundChannel=sound.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);	
		}
		
		
		private function soundFinished(e:Event):void{
			
			 soundChannel=sound.play(0);
			 soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
		}
		
		public function soundStop():void{
			 
			if(soundChannel!=null){
			   soundChannel.stop();
			}
		}
		
		public function dispose():void{
			
			soundStop();
            soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundFinished);
		    soundChannel=null;
		    sound=null;
		}

	}
}
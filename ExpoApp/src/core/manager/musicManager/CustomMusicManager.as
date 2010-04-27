package core.manager.musicManager
{
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	
	public class CustomMusicManager
	{
	   private static var instance:CustomMusicManager
	   private var sound:Sound;
	   private var soundChannel:SoundChannel;
	   private var resumeTime:Number;
	   private var soundLoaderContext:SoundLoaderContext;
		public function CustomMusicManager()
		{
		   if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("不能实例化");
			}
			init();
		}
		private function init():void
		{
			soundLoaderContext=new SoundLoaderContext(1000,true);
			ScriptManager.getInstance().addApi(ScriptName.LOAD_CUSTOM_MUSIC,loadCustomMusic);
			ScriptManager.getInstance().addApi(ScriptName.DISPOSE_CUSTOM_MUSIC,dispose);
		}
		public static function getInstance():CustomMusicManager
		{
			if(instance==null) return new CustomMusicManager();
			return instance;
		}
		
		public function loadCustomMusic(url:String):void{
		    if(url!="" && url!=null)
		    {
			    sound=new Sound();
				sound.load(new URLRequest(url),soundLoaderContext);
				resumeTime = 0;
				soundChannel=sound.play();
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
		    }
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
		
		public function dispose():void{
			
			soundStop();
			MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
		    soundChannel=null;
		    sound=null;
		}

	}
}
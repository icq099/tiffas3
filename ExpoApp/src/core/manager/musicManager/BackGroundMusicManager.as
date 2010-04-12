package core.manager.musicManager
{
	import core.manager.sceneManager.SceneManager;
	import core.manager.sceneManager.event.SceneChangeEvent;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	
	public class BackGroundMusicManager
	{
	   private static var instance:BackGroundMusicManager
	   private var sound:Sound;
	   private var soundChannel:SoundChannel;
	   private var resumeTime:Number;
//	   private var backGroundMusicModel:BackGroundMusicModel;
	   private var currentMusic:String
	   private var _hasBackGroundSound:Boolean=true;
	   private var soundLoaderContext:SoundLoaderContext
		public function BackGroundMusicManager()
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
//			backGroundMusicModel=new BackGroundMusicModel();
			soundLoaderContext=new SoundLoaderContext(1000,true);
			SceneManager.getInstance().addEventListener(SceneChangeEvent.INIT,function(e:SceneChangeEvent):void{
				dispose();
			});
			SceneManager.getInstance().addEventListener(SceneChangeEvent.COMPLETE,function(e:SceneChangeEvent):void{
//				loadBackGroundMusic(backGroundMusicModel.getMusicUrl(e.id));
			});
		}
		public static function getInstance():BackGroundMusicManager
		{
			if(instance==null) return new BackGroundMusicManager();
			return instance;
		}
		
		public function loadBackGroundMusic(url:String):void{
		    if(url!="" && url!=null && _hasBackGroundSound)
		    {
		    	currentMusic=url;
			    sound=new Sound();
				sound.load(new URLRequest(url),soundLoaderContext);
				resumeTime = 0;
				soundChannel=sound.play();
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
		    }else
		    {
		    	dispose();
		    }
		}
		public function reload():void
		{
			loadBackGroundMusic(currentMusic);
		}
		private function soundFinished(e:Event):void{
			 if(sound!=null)
			 {
				 MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
				 soundChannel=sound.play(0);
				 soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
			 }
		}
		
		public function soundStop():void{
			 
			if(soundChannel!=null){
			   soundChannel.stop();
			}
		}
		public function set hasBackGroundMusic(has:Boolean):void
		{
			_hasBackGroundSound=has;
			if(!_hasBackGroundSound)
			{
				dispose();
			}else
			{
				reload();
			}
		}
		public function dispose():void{
			currentMusic=null;
			soundStop();
			MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
		    soundChannel=null;
		    sound=null;
		}

	}
}
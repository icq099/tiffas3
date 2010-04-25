package core.manager.musicManager
{
	import core.manager.MainSystem;
	import core.manager.musicManager.model.BackgroundMusicModel;
	import core.manager.sceneManager.SceneChangeEvent;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
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
	   private var backGroundMusicModel:BackgroundMusicModel;
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
			backGroundMusicModel=new BackgroundMusicModel();
			soundLoaderContext=new SoundLoaderContext(1000,true);
			MainSystem.getInstance().addEventListener(SceneChangeEvent.INIT,function(e:SceneChangeEvent):void{
				dispose();
			});
			MainSystem.getInstance().addEventListener(SceneChangeEvent.COMPLETE,function(e:SceneChangeEvent):void{
				currentMusic=backGroundMusicModel.getMusicUrl(e.id);
				loadBackGroundMusic(backGroundMusicModel.getMusicUrl(e.id));
			});
			initScript();
		}
		private function initScript():void
		{
			ScriptManager.getInstance().addApi(ScriptName.LOAD_BACKGROUND_MUSIC,loadBackGroundMusic);
			ScriptManager.getInstance().addApi(ScriptName.DISPOSE_BACKGROUND_MUSIC,dispose);
		}
		public static function getInstance():BackGroundMusicManager
		{
			if(instance==null) return new BackGroundMusicManager();
			return instance;
		}
		public function loadBackGroundMusic(url:String):void{
			currentMusic=url;
		    if(url!="" && url!=null && _hasBackGroundSound)
		    {
			    sound=new Sound();
				sound.load(new URLRequest(url),soundLoaderContext);
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
			soundStop();
			MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
		    soundChannel=null;
		    sound=null;
		}

	}
}
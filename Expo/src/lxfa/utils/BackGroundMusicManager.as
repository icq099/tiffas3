package lxfa.utils
{
	import communication.Event.SceneChangeEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import lxfa.model.BackGroundMusicModel;
	import lxfa.model.CustomMusicModel;
	
	public class BackGroundMusicManager
	{
	   private static var instance:BackGroundMusicManager
	   private var sound:Sound;
	   private var soundChannel:SoundChannel;
	   private var resumeTime:Number;
	   private var backGroundMusicModel:BackGroundMusicModel;
	   
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
			backGroundMusicModel=new BackGroundMusicModel();
			MainSystem.getInstance().addEventListener(SceneChangeEvent.INIT,function(e:SceneChangeEvent):void{
				dispose();
			});
			MainSystem.getInstance().addEventListener(SceneChangeEvent.COMPLETE,function(e:SceneChangeEvent):void{
				loadBackGroundMusic(backGroundMusicModel.getMusicUrl(e.id));
			});
		}
		public static function getInstance():BackGroundMusicManager
		{
			if(instance==null) return new BackGroundMusicManager();
			return instance;
		}
		
		public function loadBackGroundMusic(url:String):void{
		    if(url!="" && url!=null)
		    {
			    sound=new Sound();
				sound.load(new URLRequest(url));
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
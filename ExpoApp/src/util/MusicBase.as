package util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	
	public class MusicBase extends EventDispatcher
	{
	   private var sound:Sound;
	   private var soundChannel:SoundChannel;
	   private var currentMusic:String
	   private var _hasBackGroundSound:Boolean=true;
	   private var soundLoaderContext:SoundLoaderContext
	   private var loop:Boolean=false;
	   public function loadBackGroundMusic(url:String,loop:Boolean=false):void{
	      	this.loop=loop;
			currentMusic=url;
		    if(url!="" && url!=null && _hasBackGroundSound)
		    {
			    sound=new Sound();
				sound.load(new URLRequest(url),soundLoaderContext);
				sound.addEventListener(Event.COMPLETE,downloaded);
		    }else
		    {
		    	dispose();
		    }
	   }
	   private function downloaded(e:Event):void
	   {
		   dispatchEvent(e);
	   }
	   public function play():void
	   {
		   if(sound!=null)
		   {
		   	   soundChannel=sound.play();
			   soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
		   }
	   }
	   //获取当前的播放位置
	   public function getPosition():int
	   {
	   	   if(soundChannel!=null)
	   	   {
	   	   	   return soundChannel.position;
	   	   }
	   	   return -1;
	   }
	   public function reload():void
	   {
		    loadBackGroundMusic(currentMusic);
	   }
	   private function soundFinished(e:Event):void{
			 if(sound!=null && loop)
			 {
				 MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
				 soundChannel=sound.play(0);
				 soundChannel.addEventListener(Event.SOUND_COMPLETE,soundFinished,false,0,true);
			 }
			 dispatchEvent(new Event(Event.SOUND_COMPLETE));
	   }
	   public function soundStop():void{
			 
			if(soundChannel!=null){
			   soundChannel.stop();
			}
	   }
	   public function dispose():void{
			soundStop();
			MemoryRecovery.getInstance().gcFun(soundChannel,Event.SOUND_COMPLETE,soundFinished);
			MemoryRecovery.getInstance().gcFun(sound,Event.COMPLETE,downloaded);
		    soundChannel=null;
		    sound=null;
	   }
	}
}
package lxfa.view.player
{
	/************************
	 * MP3播放器
	 * */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import lxfa.view.event.Mp3PlayerEvent;
	
	public class Mp3Player extends Sprite
	{
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var musicUrl:String;
		private var isPlaying:Boolean=true;
		public function Mp3Player(musicUrl:String)
		{
			this.musicUrl=musicUrl;
			initSound();
		}
		private function initSound():void
		{
			sound=new Sound(new URLRequest(musicUrl));
			sound.addEventListener(Event.COMPLETE,onComplete);
			soundChannel=sound.play();
			stop();
		}
		private function onSOUND_COMPLETE(e:Event):void
		{
			this.dispatchEvent(new Mp3PlayerEvent(Mp3PlayerEvent.COMPLETE));
		}
		private function onComplete(e:Event):void
		{
			this.dispatchEvent(e);
		}
		public function stop():void
		{
			if(isPlaying)
			{
				soundChannel.stop();
				isPlaying=false;
			}
		}
		public function play():void
		{
			if(!isPlaying)
			{
				soundChannel=sound.play(soundChannel.position);
				if(!soundChannel.hasEventListener(Event.SOUND_COMPLETE))
				{
					soundChannel.addEventListener(Event.SOUND_COMPLETE,onSOUND_COMPLETE);
				}
				isPlaying=true;
			}
		}
		public function close():void
		{
			soundChannel.stop();
			sound=null;
			soundChannel=null;
		}
	}
}
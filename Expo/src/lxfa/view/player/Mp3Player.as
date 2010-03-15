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
		private var loop:Boolean;
		public function Mp3Player(musicUrl:String,loop:Boolean=false)
		{
			this.musicUrl=musicUrl;
			this.loop=loop;
			initSound();
		}
		private function initSound():void
		{
			sound=new Sound(new URLRequest(musicUrl));
			sound.addEventListener(Event.COMPLETE,onComplete);
			if(loop)
			{
				soundChannel=sound.play(0,1000);
			}else
			{
				soundChannel=sound.play();
			}
			stop();
		}
		//播放完毕的事件
		private function onSOUND_COMPLETE(e:Event):void
		{
			this.dispatchEvent(new Mp3PlayerEvent(Mp3PlayerEvent.COMPLETE));
			soundChannel.removeEventListener(Event.SOUND_COMPLETE,onSOUND_COMPLETE);
		}
		private function onComplete(e:Event):void
		{
			this.dispatchEvent(e);
		}
		public function stop():void
		{
			soundChannel.stop();
		}
		public function play():void
		{
			soundChannel=sound.play(soundChannel.position);
			if(!soundChannel.hasEventListener(Event.SOUND_COMPLETE))
			{
				soundChannel.addEventListener(Event.SOUND_COMPLETE,onSOUND_COMPLETE);
			}
			isPlaying=true;
		}
		public function replay():void
		{
			soundChannel=sound.play();
			if(!soundChannel.hasEventListener(Event.SOUND_COMPLETE))
			{
				soundChannel.addEventListener(Event.SOUND_COMPLETE,onSOUND_COMPLETE);
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
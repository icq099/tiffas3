package lxfa.view.normalWindow
{
	/************************
	 * MP3播放器
	 * */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import lxfa.view.pv3dAddOn.milkmidi.display.MiniSlider;
	
	public class Mp3Player extends Sprite
	{
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var musicUrl:String;
		private var isPlaying:Boolean=true;
		private var slider:MiniSlider;//音量控制条
		public function Mp3Player(musicUrl:String)
		{
			this.musicUrl=musicUrl;
			initSound();
			initSlider();
			this.addEventListener(Event.ADDED,onAdded);
		}
		private function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED,onAdded);
			slider.width=this.parent.width-80;
			slider.x=20;
			slider.alpha=0.5;
			slider.y=this.parent.height-60;
		}
		private function initSlider():void
		{
			slider=new MiniSlider();
			slider.width=300;
			slider.value=0.5;
			this.addChild(slider);
			slider.addEventListener(MiniSlider.SLIDER,onChange);
		}
		private function onChange(e:Event):void
		{
			var st:SoundTransform=new SoundTransform();
			st.volume=slider.value/50;
			soundChannel.soundTransform=st;
		}
		private function initSound():void
		{
			sound=new Sound(new URLRequest(musicUrl));
			sound.addEventListener(Event.COMPLETE,onComplete);
			soundChannel=sound.play();
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
				isPlaying=true;
			}
		}
		public function close():void
		{
			soundChannel.stop();
			sound=null;
			slider=null;
			soundChannel=null;
		}
	}
}
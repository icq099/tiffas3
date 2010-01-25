package view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;

	public class PlayerBar extends UIComponent
	{
		[Embed (source="asset/Map.swf",symbol="PlayerBar")]
		private static const PlayerBarClass:Class;
		
		private var _player_bar:Sprite=new PlayerBarClass();
		private var _sound:Sound=new Sound();
		private var _sound_channel:SoundChannel=new SoundChannel();
		private var resumeTime:Number;
		
		public function PlayerBar()
		{
			init();
			initListener();
		}
		private function init():void{
			
			addChild(_player_bar);
			play_btn.buttonMode=true;
			stop_btn.buttonMode=true;
			pause_btn.buttonMode=true;
		
		}
		public function loadSound(url:String):void{
			
			try{
				
				_sound_channel.stop()
				_sound.close();
				
			}catch(e:Error){
				
			
			}
			
			_sound.load(new URLRequest(url));
			_sound_channel=_sound.play();
			_sound_channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
			
			showPause();
		
		}
		private function initListener():void{
			
			play_btn.addEventListener(MouseEvent.CLICK,playClickHandler);
			stop_btn.addEventListener(MouseEvent.CLICK,stopClickHandler);
			pause_btn.addEventListener(MouseEvent.CLICK,pauseClickHandler);
		
		}
		private function playClickHandler(e:Event):void{
			
			_sound_channel=_sound.play(resumeTime);
			_sound_channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
			showPause();
					
		}
		private function pauseClickHandler(e:Event):void{
			
			resumeTime=_sound_channel.position;
			_sound_channel.stop();
			showPlay();
		
		}
		private function stopClickHandler(e:Event):void{
			
			resumeTime=0;
			_sound_channel.stop();
			showPlay();
		
		}
		private function soundCompleteHandler(e:Event):void{
			
			_sound_channel=_sound.play(0);
			_sound_channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
		
		}
		private function showPlay():void{
			
			play_btn.visible=true;
			pause_btn.visible=false;
		
		}
		private function showPause():void{
			
			play_btn.visible=false;
			pause_btn.visible=true;
		
		}
		private function get play_btn():Sprite{
			
			return _player_bar.getChildByName("play_btn") as Sprite;
		
		}
		private function get stop_btn():Sprite{
			
			return _player_bar.getChildByName("stop_btn") as Sprite;
		
		}
		private function get pause_btn():Sprite{
			
			return _player_bar.getChildByName("pause_btn") as Sprite;
		
		}
		
	}
}
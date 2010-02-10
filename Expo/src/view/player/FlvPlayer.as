package view.player
{
	import ca.turbulent.media.Pyro;
	import ca.turbulent.media.events.PyroEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import yzhkof.MyGraphy;

	public class FlvPlayer extends Sprite
	{
		private static const WIDTH:Number=380;
		private static const HEIGHT:Number=285;
		
		private var controler:PlayerBottomControler=new PlayerBottomControler();
		private var player:Pyro=new Pyro(WIDTH,HEIGHT-43,Pyro.STAGE_EVENTS_MECHANICS_ALL_OFF);
		private var background:Sprite=MyGraphy.drawRectangle(WIDTH,HEIGHT-43);
		
		public function FlvPlayer()
		{
			super();
			init();
			initListener();
			
		}
		public function loadFlv(url:String):void{
			
			player.autoPlay=false;
			player.play(url);
			controler.x+=6;
		}
		public function stopAll():void{
			try{
				
				player.stop();
				player.close();
				
			}catch(e:Error){
			
			}
		
		}
		override public function set width(value:Number):void{
			
			player.width=controler.width=background.width=value;
		
		}
		override public function get width():Number{
			
			return player.width;
		
		}
		override public function set height(value:Number):void{
			
			player.height=background.height=value-controler.height;
			
			controler.y=player.height;
		
		}
		override public function get height():Number{
			
			return player.height+controler.height;
		
		}
		private function initListener():void{
			
			controler.addEventListener("play_click",playClickHandler);
			controler.addEventListener("pause_click",pauseClickHandler);
			controler.progressbar.position_btn.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			controler.addEventListener(FlashEvent.PROGRESS_DRAG,progressDragHandler);
			
			player.addEventListener(Event.ENTER_FRAME,bufferHandler);
			player.addEventListener(PyroEvent.COMPLETED,complaeteHandler);
			
			addEventListener(Event.ENTER_FRAME,progressHandler);
		
		}
		private function init():void{
			
			addChild(background);
			addChild(controler);
			addChild(player);
			controler.y=player.height;
		
		}
		private function playClickHandler(e:Event):void{
			
			player.play();	
		
		}
		private function pauseClickHandler(e:Event):void{
			
			player.pause();
		
		}
		private function bufferHandler(e:Event):void{
			
			controler.progressbar.progress_mc.scaleX=player.bytesLoaded/player.bytesTotal;
			if(player.bytesLoaded>=player.bytesTotal){
				player.removeEventListener(Event.ENTER_FRAME,bufferHandler);			
			}
		
		}
		private function progressHandler(e:Event):void{
			
			controler.progressbar.position_btn.x=controler.progressbar.back_mc.width*(player.time/player.duration);
			controler.time_text.text=player.formattedTime+"/"+player.formattedDuration;
		
		}
		private function progressDragHandler(e:FlashEvent):void{
			
			player.seek(Number(e.obj)*player.duration);
		
		}
		private function dragDownHandler(e:Event):void{
			
			removeEventListener(Event.ENTER_FRAME,progressHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler,false,0,true);
		
		}
		private function dragUpHandler(e:Event):void{
			
			addEventListener(Event.ENTER_FRAME,progressHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		
		}
		private function complaeteHandler(e:Event):void{
			
			setStop();
		
		}
		private function setStop():void{
			
			controler.left_buttons.pause_btn.visible=false;
			controler.left_buttons.play_btn.visible=true;
			player.seek(0);
			player.pause();
		
		}
		
		
	}
}
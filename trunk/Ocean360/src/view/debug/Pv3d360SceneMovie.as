package view.debug
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	
	import mx.controls.Button;
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import view.Pv3d360Scene;
	
	import yzhkof.AddToStageSetter;
	import yzhkof.debug.debugTrace;

	public class Pv3d360SceneMovie extends Pv3d360Scene
	{
		public function Pv3d360SceneMovie(czoom:Number=11, pdetail:Number=50)
		{
			super(czoom, pdetail);
		}
		override protected function init():void{
			
			super.init();
			AddToStageSetter.delayExcuteAfterAddToStage(this,function():void{
				
				var app:Object=Application.application;
				var player:UIComponent=new UIComponent();
				var loader:Loader;
				player.mouseChildren=false;
				player.mouseEnabled=false;
				player.alpha=0.4;
				var button:Button=new Button();
				button.y=200;
				app.addChild(button);
				app.addChild(player);
				
				var fun_key:Function=function(e:KeyboardEvent):void{
					
					if(e.keyCode==Keyboard.LEFT){
						
						MovieClip(loader.content).gotoAndStop(0);
					
					}else if(e.keyCode==Keyboard.RIGHT){
						
						MovieClip(loader.content).gotoAndStop(MovieClip(loader.content).totalFrames-1);
					
					}
				
				}
				stage.addEventListener(KeyboardEvent.KEY_DOWN,fun_key);
				button.addEventListener(MouseEvent.CLICK,function(e:Event):void{
					
					try{
						
						player.removeChild(loader);
						loader.close();
						loader.unloadAndStop();
					
					}catch(e:Error){
					
					}
					var file:FileReference=new FileReference();
					file.browse();
					file.addEventListener(Event.SELECT,function(e:Event):void{
						
						file.load();
					
					});
					file.addEventListener(Event.COMPLETE,function(e:Event):void{
						
						loader=new Loader()
						player.addChild(loader);
						loader.loadBytes(file.data);
					
					});
					
				});
			
			})
			
		
		}
		override protected function chageCompleteHandler(e:Event):void{
			
			super.chageCompleteHandler(e);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void{				
				if(e.keyCode==Keyboard.ENTER){
					
					draw();
					debugTrace("rotationX:"+camera.rotationX,"rotationY:"+camera.rotationY);
					
				}
			
			})
		
		}
		
	}
}
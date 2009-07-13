package yzhkof
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class BasicCameraContrler extends EventDispatcher
	{
		public var camera:Object;
		public var move_speed:Number;
		public var rota_speed:Number;
		private var active_object:DisplayObject;
		private var pre_x:Number;
		private var pre_y:Number;
		private var weak_reference:Boolean;
		private var rota:Boolean=false;
		
		public function BasicCameraContrler(active_object:DisplayObject,camera:Object,weak_reference:Boolean=true,move_speed:Number=10,rota_speed:Number=0.3)
		{
			
			this.camera=camera;
			this.active_object=active_object;
			this.weak_reference=weak_reference;
			this.move_speed=move_speed;
			this.rota_speed=rota_speed;
			enable();				
			
		}
		public function enable():void{
			
			active_object.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler,false,0,weak_reference);
			active_object.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,weak_reference);
			active_object.addEventListener(Event.ENTER_FRAME,keyDownHandler,false,0,weak_reference);
			KeyMy.startListener(active_object.stage);
			//active_object.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		
		}
		public function disable():void{
			
			KeyMy.stopListener();
			active_object.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			active_object.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		
		}
		private function keyDownHandler(e:Event):void{
			
			var updataed:Boolean=false;
			
			if(KeyMy.isDown(87)){
				
				camera.moveForward(move_speed);
				updataed=true;
				
			}
			if(KeyMy.isDown(83)){
				
				camera.moveBackward(move_speed);
				updataed=true;
				
			}
			if(KeyMy.isDown(65)){
				
				camera.moveLeft(move_speed);
				updataed=true;
				
			}
			if(KeyMy.isDown(68)){
				
				camera.moveRight(move_speed);
				updataed=true;
				
			}
			if(KeyMy.isDown(32)){
				
				camera.moveUp(move_speed);
				updataed=true;
				
			}
			if(KeyMy.isDown(17)){
				
				camera.moveDown(move_speed);
				updataed=true;
				
			}
			if((updataed) || (rota)){
				
				dispatchEvent(new CamereaControlerEvent(CamereaControlerEvent.UPDATA));
				
			}else if(!rota){
				
				dispatchEvent(new CamereaControlerEvent(CamereaControlerEvent.UPDATAED));
			
			}
		
		}
		private function mouseDownHandler(e:MouseEvent):void{
			
			active_object.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			pre_x=active_object.mouseX;
			pre_y=active_object.mouseY;
		
		}
		private function mouseUpHandler(e:MouseEvent):void{
			
			rota=false;
			active_object.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		
		}
		private function mouseMoveHandler(e:MouseEvent):void{
			
			rota=true;
			camera.rotationX+=(pre_y-active_object.mouseY)*rota_speed;
			if (Math.abs(camera.rotationX)>90) {
				camera.rotationX=camera.rotationX>0?90:- 90;
			}

			camera.rotationY+=(active_object.mouseX-pre_x)*rota_speed;
			
			pre_x=active_object.mouseX;
			pre_y=active_object.mouseY;
		
		}

	}
}
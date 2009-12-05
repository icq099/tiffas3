package  yzhkof
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class CameraRotationControler extends EventDispatcher
	{
		public var camera:Object;
		public var rota_speed:Number;
		private var active_object:DisplayObject;
		private var pre_x:Number;
		private var pre_y:Number;
		private var _goto_rotaX:Number=0;
		private var _goto_rotaY:Number=0;
		private var weak_reference:Boolean;
		private var rota:Boolean=false;
		private var tween_speed:Number;
		
		private var limit_flag:Boolean=false;
		private var _limit_rotationX_Max:Number;
		private var _limit_rotationX_Min:Number;
		private var _limit_rotationY_Max:Number;
		private var _limit_rotationY_Min:Number;
		
		private var dispatched:Boolean=false;
		
		public function CameraRotationControler(active_object:DisplayObject,camera:Object,weak_reference:Boolean=true,tween_speed:Number=0.2,rota_speed:Number=0.3)
		{
			
			this.camera=camera;
			this.active_object=active_object;
			this.weak_reference=weak_reference;
			this.rota_speed=rota_speed;
			this.tween_speed=tween_speed;
			goto_rotaX=camera.rotationX;
			goto_rotaY=camera.rotationY;
			enable();
			
		}
		public function enable():void{
			
			active_object.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler,false,0,weak_reference);
			active_object.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,weak_reference);
			active_object.addEventListener(Event.ENTER_FRAME,enterframeHandler);
		
		}
		public function disable():void{
			
			active_object.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			active_object.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			active_object.removeEventListener(Event.ENTER_FRAME,enterframeHandler);
		
		}
		//直接设置相机rotation，有缓动
		public function setGotoRotation(rotaX:Number,rotaY:Number):void{
			
			camera.rotationY=getShortcut(camera.rotationY);
			rotaY=getShortcut(rotaY);
			
			goto_rotaX=camera.rotationX+rotaX;
			goto_rotaY=camera.rotationY+rotaY;
			if (Math.abs(goto_rotaX)>90) {
				goto_rotaX=goto_rotaX>0?90:- 90;
			}
			dispatched=false;
		
		}
		//直接设置相机rotation，无缓动
		public function setRotation(rotaX:Number,rotaY:Number):void{
			
			goto_rotaX=camera.rotationX+rotaX;
			goto_rotaY=camera.rotationY+rotaY;
			if (Math.abs(goto_rotaX)>90) {
				goto_rotaX=goto_rotaX>0?90:- 90;
			}
			camera.rotationX=goto_rotaX;
			camera.rotationY=goto_rotaY;
		
		}
		public function setLimit(rotaionYMin:Number,rotaionYMax:Number,rotationXMin:Number=-90,rotationXMax:Number=90):void{
			
			limit_flag=true;
			
			_limit_rotationX_Min=rotationXMin;
			_limit_rotationX_Max=rotationXMax;
			_limit_rotationY_Min=rotaionYMin;
			_limit_rotationY_Max=rotaionYMax;
			
			checkLimit();
		
		}
		public function unLimit():void{
			
			limit_flag=false;
			checkLimit();
		
		}
		private function checkLimit():void{
			
			goto_rotaX=goto_rotaX;
			goto_rotaY=goto_rotaY;
			
			//setRotation(goto_rotaX,goto_rotaY);
		
		}
		private function set goto_rotaX(value:Number):void{
						
			if(limit_flag){
				if(value>_limit_rotationX_Max){
					
					_goto_rotaX=_limit_rotationX_Max;
				
				}else if(value<_limit_rotationX_Min){
					
					_goto_rotaX=_limit_rotationX_Min;
								
				}else{
					
					_goto_rotaX=value;
					
				}
			}else{
					 
					_goto_rotaX=value;
					
			}
		
		}
		private function get goto_rotaX():Number{
			
			return _goto_rotaX;
		
		}
		private function set goto_rotaY(value:Number):void{
			
			if(limit_flag){
				if(value>_limit_rotationY_Max){
					
					_goto_rotaY=_limit_rotationY_Max;
				
				}else if(value<_limit_rotationY_Min){
					
					_goto_rotaY=_limit_rotationY_Min;
								
				}else{
					
					_goto_rotaY=value;
					
				}
			}else{
					
					_goto_rotaY=value;
					
			}
			
		}
		private function get goto_rotaY():Number{
			
			return _goto_rotaY;
		
		}
		private function mouseDownHandler(e:MouseEvent):void{
			
			active_object.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			
			pre_x=active_object.mouseX;
			pre_y=active_object.mouseY;
		
		}
		private function mouseUpHandler(e:Event):void{
			
			active_object.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		
		}
		private function mouseMoveHandler(e:Event):void{
			
			goto_rotaX+=(pre_y-active_object.mouseY)*rota_speed;
			if (Math.abs(goto_rotaX)>90) {
				goto_rotaX=goto_rotaX>0?90:- 90;
			}

			goto_rotaY+=(active_object.mouseX-pre_x)*rota_speed;
			
			pre_x=active_object.mouseX;
			pre_y=active_object.mouseY;
		
		}
		private function enterframeHandler(e:Event):void{
			
			rota=true;
			
			camera.rotationX+=tween_speed*(goto_rotaX-camera.rotationX);
			camera.rotationY+=tween_speed*(goto_rotaY-camera.rotationY);
			
			if((Math.abs(goto_rotaX-camera.rotationX)<0.1)&&(Math.abs(goto_rotaY-camera.rotationY)<0.1)){
				
				rota=false;
				//camera.rotationX=goto_rotaX;
				//camera.rotationY=goto_rotaY;
				if(!dispatched){
					dispatchEvent(new CamereaControlerEvent(CamereaControlerEvent.UPDATAED));
					dispatched=true;
				}
				
			}else{
				
				dispatchEvent(new CamereaControlerEvent(CamereaControlerEvent.UPDATA));
				dispatched=false;
			
			}
		
		}
		private function getShortcut(rota:Number):Number{
			
			rota%=360;
				
			if(rota>180){
				
				rota-=360;
			
			}else if(rota<-180){
				
				rota+=360
			
			}
			
			return rota;
		
		}
	}
}
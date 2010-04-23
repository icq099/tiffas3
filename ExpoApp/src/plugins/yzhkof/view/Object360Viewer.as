package plugins.yzhkof.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BlurFilter;
	
	import view.loadings.LoadingSimpleProgressBar;

	public class Object360Viewer extends Sprite
	{
		private var loader:ObjectPictureLoader=new ObjectPictureLoader();
		
		private var _rotationY:Number;
		private var _rotationX:Number;
		
		private var v_count:int;
		private var h_count:int;
		private var current_v_count:int=0;
		private var current_h_count:int=0;
		
		private var current_picture:Bitmap;
		
		private var init_rotationX:Number;
		private var init_rotationY:Number;
		
		private var loading_mc:LoadingSimpleProgressBar=new LoadingSimpleProgressBar();
		
		//控制角度时的变量
		private var pre_mouseX:Number;
		private var pre_mouseY:Number;
		
		private var des_rotationX:Number;
		private var des_rotationY:Number;
		
		private const MOVE_SPEED:Number=0.3;
		
		public function Object360Viewer(obj_rotationX:Number=180,obj_rotaionY:Number=270)
		{			
			
			init_rotationX=obj_rotationX;
			init_rotationY=obj_rotaionY;
			loading_mc.x=150;
			loading_mc.y=150;
			
		}
		public function load(i_picture_name_pre:String,i_v_count:int,i_h_count:int,i_picture_type:String="jpg",i_v_name_unit:Number=10000,offset_v:int=0):void{
			
			h_count=i_h_count;
			v_count=i_v_count;
			
			addChild(loading_mc);
						
			loader.load(i_picture_name_pre,i_v_count,i_h_count,i_picture_type,i_v_name_unit,offset_v);
			loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgressEvent);
		
		}
		private function onCompleteHandler(e:Event):void{
			
			initDisplayObject();
			initControler();			
			dispatchEvent(e);
		
		}
		private function initDisplayObject():void{
						
			objRotationY=init_rotationY;
			objRotationX=init_rotationX;
			des_rotationX=init_rotationX;
			des_rotationY=init_rotationY;
			
			removeChild(loading_mc);
		
		}
		private function initControler():void{
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		
		}
		private function onMouseMoveHandler(e:Event):void{
			
			des_rotationY+=pre_mouseX-mouseX;
			des_rotationX+=(pre_mouseY-mouseY)*2;
			if(des_rotationX<=0){
				
				des_rotationX=0;
			
			}
			if(des_rotationX>360){
				
				des_rotationX=360
			
			}
			pre_mouseX=mouseX;
			pre_mouseY=mouseY
		
		}
		private function onEnterFrame(e:Event):void{
			
			this.filters=[new BlurFilter(0.1*(Math.abs(des_rotationY-objRotationY)),0)];
			objRotationY+=MOVE_SPEED*(des_rotationY-objRotationY);
			objRotationX+=MOVE_SPEED*(des_rotationX-objRotationX);
		
		}
		private function onMouseDownHandler(e:Event):void{
			
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
			pre_mouseX=mouseX;
			pre_mouseY=mouseY;
		
		}
		private function onMouseUpHandler(e:Event):void{
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
		
		}
		private function onProgressEvent(e:ProgressEvent):void{
			
			loading_mc.updateByProgressEvent(e);
		
		}
		public function set objRotationY(value:Number):void{
			
			var pre_count:int=current_h_count;
			_rotationY=value;
			current_h_count=int((((_rotationY>0?_rotationY:_rotationY%360+360)%360)/360)*(h_count));
			
			if(current_h_count!=pre_count){
				
				if(current_picture!=null){
					
					removeChild(current_picture);
					
				}
				
				addChild(loader.picture[current_v_count][current_h_count]);
			
			}
		}
		public function set objRotationX(value:Number):void{
			
			var pre_count:int=current_v_count;
			_rotationX=value;
			current_v_count=int((((_rotationX>0?_rotationX:_rotationX%360+360)%360)/360)*(v_count));
			
			if(current_v_count!=pre_count){
				
				if(current_picture!=null){
					
					removeChild(current_picture);
					
				}
				
				addChild(loader.picture[current_v_count][current_h_count]);
			
			}
		}
		public function get objRotationX():Number{
			
			return _rotationX;
		
		}
		public function get objRotationY():Number{
			
			return _rotationY;
		
		}
		
	}
}
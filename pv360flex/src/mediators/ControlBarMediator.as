package mediators
{
	import facades.FacadePv;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxys.PTravel;
	
	
	
  
	public class ControlBarMediator extends Mediator
	{  
		private var travel:PTravel;
		public static const NAME:String="ControlBarMediator";
		
		
		public function ControlBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		public function get control_bar():CameraControlBar{
			
			return viewComponent as CameraControlBar;
		
		}
		
		//收到感兴趣的消息
		public override function listNotificationInterests():Array{
			
			return [
			
				FacadePv.LOAD_XML_COMPLETE
			
			];
		
		}
		
		//收到感兴趣消息后，对control_bar的按键处理
		public override function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case FacadePv.LOAD_XML_COMPLETE:
				
				
				    travel=facade.retrieveProxy(PTravel.NAME) as PTravel;
				  
					control_bar.addEventListener("up",function(e:Event):void{
						
						travel.setCameraRotaion(20);
					
					})
					//travel.getCamera();
					control_bar.addEventListener("down",function(e:Event):void{
						
						travel.setCameraRotaion(-20);
					})
					
					control_bar.addEventListener("left",function(e:Event):void{
						
						travel.setCameraRotaion(0,-30);
					})
					
					control_bar.addEventListener("right",function(e:Event):void{
						
						travel.setCameraRotaion(0,30);
					})
					
					
					
					
					
				 	control_bar.addEventListener("zoom_in_down",plus);
					
			
					control_bar.stage.addEventListener(MouseEvent.MOUSE_UP,plusStop,false,0,true);  
					
					control_bar.stage.addEventListener(MouseEvent.MOUSE_UP,minusStop,false,0,true);
					
					control_bar.addEventListener("zoom_out_down",minus)
					
					initKeyControl()
		
                    break;
			
			}

		}
		
		private function initKeyControl():void{
			
			control_bar.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		
		}
		private function onKeyDown(e:KeyboardEvent):void{
			
			if(e.keyCode==38){
				
				travel.setCameraRotaion(20);
			
			}
			if(e.keyCode==40){
				
				travel.setCameraRotaion(-20);
			
			}
			if(e.keyCode==39){
				
				travel.setCameraRotaion(0,30);
			
			}
			if(e.keyCode==37){
				
				travel.setCameraRotaion(0,-30);
			
			}
			if(e.keyCode==33){
				
				plusMove(null);
			
			}
			if(e.keyCode==34){
				
				minusMove(null);
			
			}
			
		}
	     private function plus(e:Event):void{
						
				  control_bar.addEventListener(Event.ENTER_FRAME,plusMove)
						   
		}
		
		
		
		
	    private function plusMove(e:Event):void{
	       	
	      
	        if(travel.cameraFocus+3<105){
					    
				travel.cameraFocus+=3;
				 
			}
			else{
				
				travel.cameraFocus=105; 
						     
			}
	    }
	               
        private function plusStop(e:Event):void{
        	
        	control_bar.removeEventListener(Event.ENTER_FRAME,plusMove);
        	
        }        
        
        
        
        private function minus(e:Event):void{
        	
        	control_bar.addEventListener(Event.ENTER_FRAME,minusMove);
        	 
        }
        
        
        private function minusMove(e:Event):void{
        	
        	if(travel.cameraFocus-3>62.2){
						   
				travel.cameraFocus-=3;
						 
		    }
			else{
		        
		           travel.cameraFocus=62.2;
						 
			}
        }
        
        private function minusStop(e:Event):void{
        	
        	control_bar.removeEventListener(Event.ENTER_FRAME,minusMove);
        }
		
	}

}

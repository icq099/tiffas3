package lsd.util
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lsd.Event.PopUpEvent;
	import lsd.Event.SendEffectEvent;
	import lsd.view.PopUpDocument;
	import lsd.view.PopUpWindow;
	
	import mx.controls.SWFLoader;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class SwfPlayer extends SWFLoader
	{
		private var path:String
		private var swfWidth:int;
		private var swfHeight:int;
		private var pop:IFlexDisplayObject;
		private var _effect:String;
		private var _pop:String;
		
		public function SwfPlayer(path:String,x:int,y:int,pop:String,effect:String)
		{
			super();
			this.path=path;
			this.x=x;
			this.y=y;
			this._effect=effect;
			this._pop=pop;
			this.maintainAspectRatio=true;//关键
			this.scaleContent=true;//关键
			this.load(path);
			this.addEventListener(MouseEvent.MOUSE_DOWN,dragMovie);
			this.addEventListener(MouseEvent.MOUSE_UP,drogMovie);
			this.doubleClickEnabled=true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,popinit);
			
			this.addEventListener(PopUpEvent.POPUP,popUp_fun);
			
		}
		
		private function popinit(e:Event):void{
			
		   this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP,_pop));
		   
		}
		
		private function dragMovie(e:Event):void{
			
			this.startDrag();
		}
		
		private function drogMovie(e:Event):void{
			
			this.stopDrag();
		}
		public function dispose():void
		{
			this.unloadAndStop();
			this.removeEventListener(MouseEvent.MOUSE_DOWN,dragMovie);
			this.removeEventListener(MouseEvent.MOUSE_UP,drogMovie);
			this.removeEventListener(PopUpEvent.POPUP,popUp_fun);
			
		}
		
		private function sendEffect():void{
             
            Application.application.dispatchEvent(new SendEffectEvent(SendEffectEvent.EFFECT,_effect));
		}
		
		
		private function popUp_fun(e:PopUpEvent):void{
			
			if(e._popType=="PopUpWindow"){
				sendEffect();
				pop=PopUpManager.createPopUp(Application.application as DisplayObject,PopUpWindow,false);
				
			}
			else if(e._popType=="popPopUpDocument"){
				sendEffect();
				pop=PopUpManager.createPopUp(Application.application  as DisplayObject,PopUpDocument,false);
			  
           }
         
			
		}
		
		
	}
}
package lsd.CustomWindow
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;
	
	public class CustomWindow extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var loading_mc:LoadingWaveRota;
		private var _text:String;
		private var textFiled:TextField;
		private var _url:String;
		private var customUp:CustomWindowUIUp;
		public function CustomWindow(url:String,text:String)
		{  
			if(url!=null&&text!=null&&url!=""&&text!=""){
				this._url=url;
				this._text=text;
				
			}
		    loadSwf(_url);
		}
		public function loadSwf(url:String):void{
			
			swfPlayer=new SwfPlayer(url,820,403);
			initLoadingMc();
			swfPlayer.addEventListener(ProgressEvent.PROGRESS,on_flv_progress);
			swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
		}
		public function loadText():void{
		   textFiled=new TextField();
		   textFiled.text=_text
		   textFiled.wordWrap=true;
		   textFiled.x=swfPlayer.x+300
		   textFiled.y=swfPlayer.y+30
           textFiled.width=423;
		   textFiled.height=58;
		   textFiled.textColor=0xFFFFFF;
		   textFiled.mouseEnabled=false;
		   textFiled.mouseWheelEnabled=false;
		   this.addChild(textFiled);
			
		}
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			loading_mc.x=swfPlayer.x+swfPlayer.width/2
			loading_mc.y=swfPlayer.y+swfPlayer.height/2
			this.addChild(Toolyzhkof.mcToUI(loading_mc));
		}
		
		private function on_flv_progress(e:ProgressEvent):void //FLV加载完毕
		{
			loading_mc.updateByProgressEvent(e);
		}
		private function on_swf_complete(e:Event):void
		{
			MemoryRecovery.getInstance().gcObj(loading_mc);
			this.addChild(swfPlayer);
			customUp=new CustomWindowUIUp();
			customUp.x=swfPlayer.x+643;
			customUp.y=swfPlayer.y-61;
			this.addChild(customUp);
			dispatchEvent(new CustomWindowEvent(CustomWindowEvent.SWF_COMPLETE));
			loadText();
			addEvent();	
		}
		private function addEvent():void{
			customUp.up.addEventListener(MouseEvent.CLICK,up_click);
			customUp.down.addEventListener(MouseEvent.CLICK,down_click);
			customUp.Btn_Close.addEventListener(MouseEvent.CLICK,close_click);
		}
		
		private function up_click(e:MouseEvent):void{
			
			if(textFiled.scrollV>1){
				
				textFiled.scrollV-=1;
			}
		
		}
		
	   private function down_click(e:MouseEvent):void{
			if(textFiled.scrollV<textFiled.numLines){
				
				textFiled.scrollV+=1;
			}
		}

		private function close_click(e:MouseEvent):void{
			
			 dispatchEvent(new CustomWindowEvent(CustomWindowEvent.WINDOW_CLOSE));			  
			 
		}
		
		private function removeAreas():void{
			
			CollisionManager.getInstance().removeCollision("close");
			CollisionManager.getInstance().removeCollision("down");
			CollisionManager.getInstance().removeCollision("up");
		}
		
		
		
		public function dispose():void{
			MemoryRecovery.getInstance().gcFun(customUp.up,MouseEvent.CLICK,up_click);
			MemoryRecovery.getInstance().gcFun(customUp.down,MouseEvent.CLICK,down_click);
			MemoryRecovery.getInstance().gcFun(customUp.Btn_Close,MouseEvent.CLICK,close_click);
			MemoryRecovery.getInstance().gcFun(swfPlayer,ProgressEvent.PROGRESS,on_flv_progress);
			MemoryRecovery.getInstance().gcFun(swfPlayer,Event.COMPLETE,on_swf_complete);
			MemoryRecovery.getInstance().gcObj(swfPlayer,true);
			MemoryRecovery.getInstance().gcObj(textFiled);
			removeAreas();
		}
	}
}
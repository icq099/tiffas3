package lsd.CustomWindow
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;
	
	public class CustomWindow extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var loading_mc:LoadingWaveRota;
		private var textFiled:TextArea
		
		public function CustomWindow()
		{
			
			loadSwf("swf/mingzhubaimei.swf")
			
		}
		
		public function loadSwf(url:String):void{
			
			swfPlayer=new SwfPlayer(url,820,403);
			initLoadingMc();
			swfPlayer.addEventListener(ProgressEvent.PROGRESS,on_flv_progress);
			swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
			
			
		}
		public function loadText():void{
		   textFiled=new TextArea();
		   textFiled.text="dfaf"
		   textFiled.x=100
		    textFiled.y=50
		  // textFiled.x=740
		   //textFiled.y=115;
		   textFiled.width=100;
		   textFiled.height=100;
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
			addAreas();
			trace(swfPlayer.x);
			trace(swfPlayer.y);
			
		}
		private function addAreas():void{
			  
		    var upAreas:Array=[[[740+this.x, 100+this.y], [750+this.x, 110+this.y]]];
		    var downAreas:Array=[[[740+this.x, 146+this.y], [749+this.x, 155+this.y]]];
		    var closeArea:Array=[[[780+this.x, 88+this.y], [799+this.x, 104+this.y]]];
		    CollisionManager.getInstance().addCollision(closeArea,close_click,"close");
            CollisionManager.getInstance().addCollision(downAreas,down_click,"down");
		    CollisionManager.getInstance().addCollision(upAreas,up_click,"up");
		    
			CollisionManager.getInstance().showCollision();
		}
		
		private function up_click():void{
			
			trace("a");
		}
		private function down_click():void{
			
			trace("b");
		}
		private function close_click():void{
			
			trace("c ");
		}

	}
}
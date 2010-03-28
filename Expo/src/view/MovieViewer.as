/* 抛出Event.COMPLETE代表movie播放完毕 */

package view
{
	import communication.Event.ScriptAPIAddEvent;
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import gs.TweenLite;
	
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	
	import mx.core.Application;
	
	import yzhkof.Toolyzhkof;
	
	public class MovieViewer extends Sprite
	{
		private var loader:FLVPlayer;
		private var movie:MovieClip;
		private var cover:Sprite;
		private var loading_mc:LoadingWaveRota;
		private var URL:String;
		public function MovieViewer()
		{
			
		}
		public function loadMovie(URL:String):void{
			this.URL=URL;
			MemoryRecovery.getInstance().gcObj(loading_mc);
			loading_mc=new LoadingWaveRota();
			MainSystem.getInstance().runAPIDirectDirectly("showPluginById",["FlvModule"]);
			MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.ADD_API,on_add_api);
			Application.application.addChild(Toolyzhkof.mcToUI(loading_mc));
			loading_mc.x=this.stage.stageWidth/2;
			loading_mc.y=this.stage.stageHeight/2;
			
			TweenLite.from(loading_mc,0.5,{alpha:0});
		
		}
		private function on_add_api(e:ScriptAPIAddEvent):void
		{
			if(e.fun_name=="addFlv"){
				MainSystem.getInstance().runAPIDirectDirectly("addFlv",[URL,false]);
				MainSystem.getInstance().getPlugin("FlvModule").addEventListener(FLVPlayerEvent.COMPLETE,onCompleteHandler);
				MainSystem.getInstance().getPlugin("FlvModule").addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			}
			MainSystem.getInstance().removeEventListener(ScriptAPIAddEvent.ADD_API,on_add_api);
		}
		public function enableCover():void{
			
			if(cover==null){
				
				drawCover();
				addChild(cover)
				
			}
		
		}
		public function disableCover():void{
			
			try{
				removeChild(cover);
				cover=null;
			}catch(e:Error){
			
			}
		
		}
		public function disappear():void{
		}
		private function onProgressHandler(e:ProgressEvent):void{
			
			loading_mc.updateByProgressEvent(e);
		    if(e.bytesLoaded==e.bytesTotal)
		    {
				loading_mc.parent.removeChild(loading_mc);
			    MainSystem.getInstance().getPlugin("FlvModule").addEventListener(Event.CLOSE,movieComplete);
		    }
		}
		private function drawCover():void{
			
			cover=new Sprite();
			cover.graphics.lineStyle();
			cover.graphics.beginFill(0xFFFFFF);
			cover.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			cover.alpha=0;
		
		}
		private function onInit(e:Event):void{
			
//			movie=MovieClip(loader.content);
//			movie.stop();
		
		}
		private function onCompleteHandler(e:FLVPlayerEvent):void{
			
			loading_mc.parent.removeChild(loading_mc);
			MainSystem.getInstance().getPlugin("FlvModule").removeEventListener(FLVPlayerEvent.COMPLETE,onCompleteHandler);
		    MainSystem.getInstance().getPlugin("FlvModule").addEventListener(Event.CLOSE,movieComplete);
		}
		private function movieComplete(e:Event):void{
			var dis:DisplayObject=MainSystem.getInstance().getPlugin("FlvModule");
			MemoryRecovery.getInstance().gcFun(dis,Event.CLOSE,movieComplete);
			MainSystem.getInstance().startRender();
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}
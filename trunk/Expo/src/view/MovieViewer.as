/* 抛出Event.COMPLETE代表movie播放完毕 */

package view
{
	import communication.MainSystem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import gs.TweenLite;
	
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.Application;
	
	import yzhkof.Toolyzhkof;
	import yzhkof.loadings.LoadingWaveRota;
	
	public class MovieViewer extends Sprite
	{
		private var loader:FLVPlayer;
		private var movie:MovieClip;
		private var cover:Sprite;
		private var loading_mc:LoadingWaveRota;
		
		public function MovieViewer()
		{
			
		}
		public function loadMovie(URL:String):void{
			
			loading_mc=new LoadingWaveRota();
			MainSystem.getInstance().runAPIDirect("addFlv",[URL]);
			MainSystem.getInstance().getPlugin("FlvModule").addEventListener(Event.COMPLETE,onCompleteHandler);
//			loader.addEventListener(Event.INIT,onInit);
			MainSystem.getInstance().getPlugin("FlvModule").addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			Application.application.addChild(Toolyzhkof.mcToUI(loading_mc));
			loading_mc.x=this.stage.stageWidth/2;
			loading_mc.y=this.stage.stageHeight/2;
			
			TweenLite.from(loading_mc,0.5,{alpha:0});
		
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
			
//			if(loader!=null){
//				
////				loader.addFrameScript(loader.totalFrames-1,null);
//				TweenLite.to(loader,2,{ease:Cubic.easeInOut,alpha:0,onComplete:function():void{
//				
////					loader=null;
//					loader.parent.removeChild(loader);
//					loader=null;
//			
//				}});
//			}
		
		}
		private function onProgressHandler(e:ProgressEvent):void{
			
			loading_mc.updateByProgressEvent(e);
		
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
		private function onCompleteHandler(e:Event):void{
			
			loading_mc.parent.removeChild(loading_mc);
//			Application.application.addChild(Toolyzhkof.mcToUI(loader));
//			TweenLite.from(loader,2,{ease:Cubic.easeInOut,alpha:0,onComplete:function():void{
//				loader.resume();
////				movie.play();
//			
//			}});
//			movie.addFrameScript(movie.totalFrames-1,movieComplete);
		MainSystem.getInstance().getPlugin("FlvModule").addEventListener(Event.CLOSE,movieComplete);
		}
		private function movieComplete(e:Event):void{
			MainSystem.getInstance().startRender();
			MainSystem.getInstance().runAPIDirect("removeFlv",[]);
			dispatchEvent(new Event(Event.COMPLETE));
		
		}

	}
}
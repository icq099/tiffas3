package lsd.SlidingPuzzle
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import lxfa.utils.MemoryRecovery;
	
	public class SlidingPuzzleGame extends Sprite
	{
		private var slidingPuzzle:SlidingPuzzle;
		private var url:Array=["img/百里柳江.jpg","img/广西体育中心.jpg","img/桂林两江机场.jpg","img/南宁大桥.jpg","img/南宁机场.jpg"]
	    private var i:int=0;
		private var puzzleGameClose:PuzzleGameClose;
		
		public function SlidingPuzzleGame()
		{
			init();
		}
		
		private function init():void{
			MainSystem.getInstance().dispatcherPluginUpdate();
			MainSystem.getInstance().dispatcherSceneChangeInit(7);
			MainSystem.getInstance().isBusy=true;
			slidingPuzzle=new SlidingPuzzle();
			puzzleGameClose=new PuzzleGameClose();
			addChild(slidingPuzzle);
			addChild(puzzleGameClose);
			puzzleGameClose.x=800;
			slidingPuzzle.loadBitmap(url[i]);
			slidingPuzzle.addEventListener(SlidingEvent.PUZZLE_CHANG,next_fun);
			slidingPuzzle.addEventListener(Event.COMPLETE,on_loaded);
			puzzleGameClose.close_btn.addEventListener(MouseEvent.CLICK,end_fun);
			this.addEventListener(SlidingEvent.PUZZLE_END,end_fun);
		}
		private function on_loaded(e:Event):void
		{
			MainSystem.getInstance().dispatcherSceneChangeComplete(7);
			MainSystem.getInstance().addSceneChangeCompleteHandler(function():void{
				//删掉自己
			},[]);
			MainSystem.getInstance().addSceneChangeInitHandler(function():void{
//				/不能玩游戏
			},[]);
			MemoryRecovery.getInstance().gcFun(slidingPuzzle,Event.COMPLETE,on_loaded);
			MainSystem.getInstance().isBusy=false;
		}
		private function next_fun(e:SlidingEvent):void{
			
			 if(url[i].toString()!="img/南宁机场.jpg")
			 {	
			 i++;
			 TweenLite.from(slidingPuzzle,1,{alpha:0});
			 
             

			 TweenLite.to(slidingPuzzle,1,{alpha:1,onStart: function():void{
			 	 
			 	 slidingPuzzle.clearPuzzle();
			 	 slidingPuzzle.loadBitmap(url[i]);
			
			 }});
			 }
			 else{
			 	
			 	dispatchEvent(new SlidingEvent(SlidingEvent.PUZZLE_END));
			 	
			 	trace("game over")
			 }
			 
		}
		private function end_fun(e:Event):void{
			
			 TweenLite.to(slidingPuzzle,1,{alpha:0,onComplete:function():void{
			          
			         //removeChild(slidingPuzzle);
			        // slidingPuzzle.parent.removeChild(slidingPuzzle);
			        
			        trace("wangjie");
			 	
			 	}});
		}
		
		
		
		
		

	}
}
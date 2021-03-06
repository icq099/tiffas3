package lsd.SlidingPuzzle
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import lxfa.utils.MemoryRecovery;
	
	import yzhkof.Toolyzhkof;
	
	public class SlidingPuzzleGame extends Sprite
	{
		private var slidingPuzzle:SlidingPuzzle;
		private var url:Array=["point/img/19-1-1.jpg","point/img/19-1-2.jpg","point/img/19-1-3.jpg","point/img/19-1-4.jpg","point/img/19-1-5.jpg"]
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
			MainSystem.getInstance().addSceneChangeCompleteHandler(dispose_sp,[]);
			MainSystem.getInstance().addSceneChangeInitHandler(function():void{
			    puzzleGameClose.close_btn.removeEventListener(MouseEvent.CLICK,end_fun);
			    puzzleGameClose.close_btn.mouseEnabled=false;
			    slidingPuzzle.mouseEnabled=false;
			},[]);
			MainSystem.getInstance().isBusy=false;
		}
		private function next_fun(e:SlidingEvent):void{
			
			 if(url[i].toString()!="point/img/19-1-5.jpg")
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
			 	
			 }
			 
		}
		private function end_fun(e:Event):void{
			
			 TweenLite.to(slidingPuzzle,1,{alpha:0,onComplete:function():void{
			          
			 	
			 	}});
		}
		private function dispose_sp():void{
			
			MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["SlidingModule"]);
		}
		public function dispose():void{
			
			MemoryRecovery.getInstance().gcFun(slidingPuzzle,SlidingEvent.PUZZLE_CHANG,next_fun);
			MemoryRecovery.getInstance().gcFun(slidingPuzzle,Event.COMPLETE,on_loaded);
			MemoryRecovery.getInstance().gcObj(slidingPuzzle,false);
			MemoryRecovery.getInstance().gcFun(puzzleGameClose.close_btn,MouseEvent.CLICK,end_fun);
			MemoryRecovery.getInstance().gcObj(puzzleGameClose);
			
		}

	}
}
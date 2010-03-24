package lsd.SlidingPuzzle
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
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
			
			slidingPuzzle=new SlidingPuzzle();
			puzzleGameClose=new PuzzleGameClose();
			addChild(slidingPuzzle);
			addChild(puzzleGameClose);
			puzzleGameClose.x=800;
			slidingPuzzle.loadBitmap(url[i]);
			slidingPuzzle.addEventListener(SlidingEvent.PUZZLE_CHANG,next_fun);
			puzzleGameClose.close_btn.addEventListener(MouseEvent.CLICK,end_fun);
			this.addEventListener(SlidingEvent.PUZZLE_END,end_fun);
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
package lsd.SlidingPuzzle
{
	import flash.display.Sprite;
	
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
		}
		private function next_fun(e:SlidingEvent):void{
			
			 if(i<5){
			 i=i+1;
			 TweenLite.to(slidingPuzzle,0.5,{alpha:0});
             slidingPuzzle.clearPuzzle();

			 TweenLite.to(slidingPuzzle,0.5,{alpha:1,onStart: function():void{
			 	 
			 	 slidingPuzzle.loadBitmap(url[i]);
			
			 }});
			 }
			 else{
			 	slidingPuzzle.clearPuzzle();
			 }
			 
		}
		
		

	}
}
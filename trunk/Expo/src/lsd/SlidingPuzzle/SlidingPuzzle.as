/* This code is from "ActionScript 3.0 Game Programming University" by Gary Rosenzweig
Copyright 2007
http://flashgameu.com
See the book or site for more information */

package lsd.SlidingPuzzle {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class SlidingPuzzle extends Sprite {
		// space between pieces and offset
		private static const pieceSpace:Number = 1;
		private static const horizOffset:Number = 0;
		private static const vertOffset:Number = 0;
		
		// number of pieces
		private static const numPiecesHoriz:int = 2;
		private static const numPiecesVert:int = 2;
		
		// random shuffle steps
		private static const numShuffle:int = 200;
		
		// animation steps and time
		private static const slideSteps:int = 10;
		private static const slideTime:int = 250;
		
		// size of pieces
		private var pieceWidth:Number;
		private var pieceHeight:Number;

		// game pieces
		private var puzzleObjects:Array;
		
		// tracking moves
		private var blankPoint:Point;
		private var slidingPiece:Object;
		private var slideDirection:Point;
		private var slideAnimation:Timer;
		
		public function SlidingPuzzle(){
			
          //  loadBitmap("img/百里柳江.jpg");
		}
		
		// get the bitmap from an external source
		public function loadBitmap(bitmapFile:String):void{
			blankPoint = new Point(numPiecesHoriz-1,numPiecesVert-1);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingDone);
			var request:URLRequest = new URLRequest(bitmapFile);
			loader.load(request);
		}
		
		// bitmap done loading, cut into pieces
		private function loadingDone(event:Event):void {
			// create new image to hold loaded bitmap
			var image:Bitmap = Bitmap(event.target.loader.content);
			pieceWidth = image.width/numPiecesHoriz;
			pieceHeight = image.height/numPiecesVert;
			
			// cut into puzzle pieces
			makePuzzlePieces(image.bitmapData);
			
			// shuffle them
			shufflePuzzlePieces();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// cut bitmap into pieces
		private function makePuzzlePieces(bitmapData:BitmapData):void{
			puzzleObjects = new Array();
			for(var x:uint=0;x<numPiecesHoriz;x++) {
				for (var y:uint=0;y<numPiecesVert;y++) {
					// skip blank spot
					if (blankPoint.equals(new Point(x,y))) continue;
					
					// create new puzzle piece bitmap and sprite
					var newPuzzlePieceBitmap:Bitmap = new Bitmap(new BitmapData(pieceWidth,pieceHeight));
					newPuzzlePieceBitmap.bitmapData.copyPixels(bitmapData,new Rectangle(x*pieceWidth,y*pieceHeight,pieceWidth,pieceHeight),new Point(0,0));
					var newPuzzlePiece:Sprite = new Sprite();
					newPuzzlePiece.addChild(newPuzzlePieceBitmap);
					addChild(newPuzzlePiece);
					
					// set location
					newPuzzlePiece.x = x*(pieceWidth+pieceSpace) + horizOffset;
					newPuzzlePiece.y = y*(pieceHeight+pieceSpace) + vertOffset;
					
					// create object to store in array
					var newPuzzleObject:Object = new Object();
					newPuzzleObject.currentLoc = new Point(x,y);
					newPuzzleObject.homeLoc = new Point(x,y);
					newPuzzleObject.piece = newPuzzlePiece;
					newPuzzlePiece.addEventListener(MouseEvent.CLICK,clickPuzzlePiece);
					puzzleObjects.push(newPuzzleObject);
				}
			}
		}
		
		// make a number of random moves
		private function shufflePuzzlePieces():void{
			for(var i:int=0;i<numShuffle;i++) {
				shuffleRandom();
			}
        }
		
		// random move
		private function shuffleRandom():void{
			// loop to find valid moves
			var validPuzzleObjects:Array = new Array();
			for(var i:uint=0;i<puzzleObjects.length;i++) {
				if (validMove(puzzleObjects[i]) != "none") {
					validPuzzleObjects.push(puzzleObjects[i]);
				}
			}
			// pick a random move
			var pick:uint = Math.floor(Math.random()*validPuzzleObjects.length);
			movePiece(validPuzzleObjects[pick],false);
		}

		private function validMove(puzzleObject:Object): String {
			// is the blank spot above
			if ((puzzleObject.currentLoc.x == blankPoint.x) &&
				(puzzleObject.currentLoc.y == blankPoint.y+1)) {
				return "up";
			}
			// is the blank spot below
			if ((puzzleObject.currentLoc.x == blankPoint.x) &&
				(puzzleObject.currentLoc.y == blankPoint.y-1)) {
				return "down";
			}
			// is the blank to the left
			if ((puzzleObject.currentLoc.y == blankPoint.y) &&
				(puzzleObject.currentLoc.x == blankPoint.x+1)) {
				return "left";
			}
			// is the blank to the right
			if ((puzzleObject.currentLoc.y == blankPoint.y) &&
				(puzzleObject.currentLoc.x == blankPoint.x-1)) {
				return "right";
			}
			// no valid moves
			return "none";
		}
		
		// puzzle piece clicked
		private function clickPuzzlePiece(event:MouseEvent):void{
			// find piece clicked and move it
			for(var i:int=0;i<puzzleObjects.length;i++) {
				if (puzzleObjects[i].piece == event.currentTarget) {
					movePiece(puzzleObjects[i],true);
					break;
				}
			}
		}
		
		// move a piece into the blank space
		private function movePiece(puzzleObject:Object, slideEffect:Boolean):void{
			// get direction of blank space
			switch (validMove(puzzleObject)) {
				case "up":
					movePieceInDirection(puzzleObject,0,-1,slideEffect);
					break;
				case "down":
					movePieceInDirection(puzzleObject,0,1,slideEffect);
					break;
				case "left":
					movePieceInDirection(puzzleObject,-1,0,slideEffect);
					break;
				case "right":
					movePieceInDirection(puzzleObject,1,0,slideEffect);
					break;
			}
		}
		
		// move the piece into the blank spot
		private function movePieceInDirection(puzzleObject:Object, dx:int,dy:int, slideEffect:Boolean):void{
			puzzleObject.currentLoc.x += dx;
			puzzleObject.currentLoc.y += dy;
			blankPoint.x -= dx;
			blankPoint.y -= dy                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ;
			
			// animate or not
			if (slideEffect) {
				// start animation
				startSlide(puzzleObject,dx*(pieceWidth+pieceSpace),dy*(pieceHeight+pieceSpace));
			} else {
				// no animation, just move
				puzzleObject.piece.x = puzzleObject.currentLoc.x*(pieceWidth+pieceSpace) + horizOffset;
				puzzleObject.piece.y = puzzleObject.currentLoc.y*(pieceHeight+pieceSpace) + vertOffset;
			}
		}
		
		// set up a slide
		private function startSlide(puzzleObject:Object,dx:Number,dy:Number):void {
			if (slideAnimation != null) slideDone(null);
			slidingPiece = puzzleObject;
			slideDirection = new Point(dx,dy);
			slideAnimation = new Timer(slideTime/slideSteps,slideSteps);
			slideAnimation.addEventListener(TimerEvent.TIMER,slidePiece);
			slideAnimation.addEventListener(TimerEvent.TIMER_COMPLETE,slideDone);
			slideAnimation.start();
		}
		
		// move one step in slide
		public function slidePiece(event:Event):void{
			slidingPiece.piece.x += slideDirection.x/slideSteps;
			slidingPiece.piece.y += slideDirection.y/slideSteps;
		}
		
		// complete slide
		private function slideDone(event:Event):void{
			slidingPiece.piece.x = slidingPiece.currentLoc.x*(pieceWidth+pieceSpace) + horizOffset;
			slidingPiece.piece.y = slidingPiece.currentLoc.y*(pieceHeight+pieceSpace) + vertOffset;
			slideAnimation.stop();
			slideAnimation = null;
			
			// check to see if puzzle is complete now
			if (puzzleComplete()) {
				dispatchEvent(new SlidingEvent(SlidingEvent.PUZZLE_CHANG));
			}
		}
		
		// check to see if all pieces are in place
		private function puzzleComplete():Boolean {
			for(var i:int=0;i<puzzleObjects.length;i++) {
				if (!puzzleObjects[i].currentLoc.equals(puzzleObjects[i].homeLoc)) {
					return false;
				}
			}
			return true;
		}
		
		// remove all puzzle pieces
		public function clearPuzzle():void {
			for (var i:Object in puzzleObjects) {
				puzzleObjects[i].piece.addEventListener(MouseEvent.CLICK,clickPuzzlePiece);
				removeChild(puzzleObjects[i].piece);
			}
			puzzleObjects = null;
		}
	   public function dispose():void{
	   	 
	   	  
	   	
	   }
		
	}
}
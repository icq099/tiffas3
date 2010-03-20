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
	
	import mx.core.UIComponent;
	
	public class SlidingPuzzle extends UIComponent {
		// space between pieces and offset
		static const pieceSpace:Number = 1;
		static const horizOffset:Number = 0;
		static const vertOffset:Number = 0;
		
		// number of pieces
		static const numPiecesHoriz:int = 4;
		static const numPiecesVert:int = 3;
		
		// random shuffle steps
		static const numShuffle:int = 200;
		
		// animation steps and time
		static const slideSteps:int = 10;
		static const slideTime:int = 250;
		
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
			
            loadBitmap("img/百里柳江.jpg");
		}
		
		
			
			
	
		
		// get the bitmap from an external source
		public function loadBitmap(bitmapFile:String) {
			blankPoint = new Point(numPiecesHoriz-1,numPiecesVert-1);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingDone);
			var request:URLRequest = new URLRequest(bitmapFile);
			loader.load(request);
		}
		
		// bitmap done loading, cut into pieces
		public function loadingDone(event:Event):void {
			// create new image to hold loaded bitmap
			var image:Bitmap = Bitmap(event.target.loader.content);
			pieceWidth = image.width/numPiecesHoriz;
			pieceHeight = image.height/numPiecesVert;
			
			// cut into puzzle pieces
			makePuzzlePieces(image.bitmapData);
			
			// shuffle them
			shufflePuzzlePieces();
		}
		
		// cut bitmap into pieces
		public function makePuzzlePieces(bitmapData:BitmapData) {
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
		public function shufflePuzzlePieces() {
			for(var i:int=0;i<numShuffle;i++) {
				shuffleRandom();
			}
        }
		
		// random move
		public function shuffleRandom() {
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

		public function validMove(puzzleObject:Object): String {
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
		public function clickPuzzlePiece(event:MouseEvent) {
			// find piece clicked and move it
			for(var i:int=0;i<puzzleObjects.length;i++) {
				if (puzzleObjects[i].piece == event.currentTarget) {
					movePiece(puzzleObjects[i],true);
					break;
				}
			}
		}
		
		// move a piece into the blank space
		public function movePiece(puzzleObject:Object, slideEffect:Boolean) {
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
		public function movePieceInDirection(puzzleObject:Object, dx,dy:int, slideEffect:Boolean) {
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
		public function startSlide(puzzleObject:Object, dx, dy:Number) {
			if (slideAnimation != null) slideDone(null);
			slidingPiece = puzzleObject;
			slideDirection = new Point(dx,dy);
			slideAnimation = new Timer(slideTime/slideSteps,slideSteps);
			slideAnimation.addEventListener(TimerEvent.TIMER,slidePiece);
			slideAnimation.addEventListener(TimerEvent.TIMER_COMPLETE,slideDone);
			slideAnimation.start();
		}
		
		// move one step in slide
		public function slidePiece(event:Event) {
			slidingPiece.piece.x += slideDirection.x/slideSteps;
			slidingPiece.piece.y += slideDirection.y/slideSteps;
		}
		
		// complete slide
		public function slideDone(event:Event) {
			slidingPiece.piece.x = slidingPiece.currentLoc.x*(pieceWidth+pieceSpace) + horizOffset;
			slidingPiece.piece.y = slidingPiece.currentLoc.y*(pieceHeight+pieceSpace) + vertOffset;
			slideAnimation.stop();
			slideAnimation = null;
			
			// check to see if puzzle is complete now
			if (puzzleComplete()) {
				clearPuzzle();
                trace("win");
			}
		}
		
		// check to see if all pieces are in place
		public function puzzleComplete():Boolean {
			for(var i:int=0;i<puzzleObjects.length;i++) {
				if (!puzzleObjects[i].currentLoc.equals(puzzleObjects[i].homeLoc)) {
					return false;
				}
			}
			return true;
		}
		
		// remove all puzzle pieces
		public function clearPuzzle() {
			for (var i in puzzleObjects) {
				puzzleObjects[i].piece.addEventListener(MouseEvent.CLICK,clickPuzzlePiece);
				removeChild(puzzleObjects[i].piece);
			}
			puzzleObjects = null;
		}
		
	}
}
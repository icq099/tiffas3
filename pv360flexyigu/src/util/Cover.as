package util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	import gs.TweenMax;
	
	public class Cover extends Sprite
	{
		private var parentMovie:Sprite;
		private var coverSquare:Sprite;
		private var coverText:TextField;
		private var blurredParent:Bitmap;
		private var cover:Cover;
		
		public function Cover(parent:Sprite)
		{
			cover=this;
			parentMovie = parent;
			super();
			// Build the "disabled" state
			coverSquare = new Sprite();
			coverSquare.graphics.beginFill(0x000000,0);
			coverSquare.graphics.drawRect(0,0,parentMovie.stage.stageWidth,parentMovie.stage.stageHeight);
			coverSquare.graphics.endFill();
			addChild(coverSquare);
			
			// Create explanatory text
			var format1:TextFormat = new TextFormat();
			format1.color = 0x000000;
			format1.size = 12;
			format1.align = "center";
			format1.font = "_sans";
			coverText = new TextField();
			coverText.text = "";
			coverText.setTextFormat(format1);
			coverText.width = parentMovie.stage.stageWidth;
			
			// Prep for blurred parent
			blurredParent = new Bitmap();
			this.addChild(blurredParent);
			parentMovie.stage.addEventListener(Event.MOUSE_LEAVE,showCover);
			parentMovie.stage.addEventListener(MouseEvent.MOUSE_MOVE,hideCover);
		}
		private function hideCover(e:MouseEvent):void
		{
			TweenLite.killTweensOf(refresh);
			this.visible = false;
				
		}
		private function showCover(e:Event):void
		{
			TweenLite.delayedCall(2,refresh);
			//refresh();
			
			// Turn on cover
						
		}
		public function refresh():void
		{
			
			var bits:BitmapData = new BitmapData(parentMovie.stage.stageWidth,parentMovie.stage.stageHeight);
			bits.draw(coverSquare);
			bits.draw(parentMovie);
			var backgroundImage:Bitmap = new Bitmap(bits);
			this.filters=[new BlurFilter(0,0,3)];
			TweenMax.to(this, 1, {blurFilter:{blurX:5, blurY:5, quality:3}});
			
			//backgroundImage.filters = new Array( new BlurFilter(6,6,4) );
			
			// Copy the blurred text and add the text
			var textOverlay:BitmapData = new BitmapData(parentMovie.stage.stageWidth,parentMovie.stage.stageHeight,false);
			textOverlay.draw(backgroundImage);
			textOverlay.draw(coverText,null,null,null,null,true);
			blurredParent.bitmapData = textOverlay;
			
			this.visible = true;
		}
	}
}
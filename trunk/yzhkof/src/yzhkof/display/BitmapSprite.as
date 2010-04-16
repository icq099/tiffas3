package yzhkof.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yzhkof.display.event.DisplayEvent;
	[Event(name="size_updata",type="yzhkof.display.event.DisplayEvent")]
	public class BitmapSprite extends RenderSprite
	{
		public var clipRect:Rectangle;
		public var blendModeOnDraw:String;
		
		//protected var bitmapData:BitmapData;
		protected var _content:Sprite=new Sprite;
		protected var drawNew:Boolean=true;
		protected var fillColor:uint;
		protected var transparent:Boolean;
		protected var updataSizeNextRend:Boolean=false;
		
		private var bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _width:Number;
		private var _height:Number;
		public function BitmapSprite(width:Number,height:Number,transparent:Boolean=false,fillColor:uint=0)
		{
			super();
			this.rendAtStage=true;
			this.drawNew=drawNew;
			this.fillColor=fillColor;
			this.transparent=transparent;
			_width=width;
			_height=height;
			_bitmapData=new BitmapData(width,height,transparent,fillColor);
			clipRect=bitmapData.rect;
			super.addChild(bitmap=new Bitmap(bitmapData));
		}
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return _content.addChild(child);
		} 
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			return _content.removeChild(child);
		}
		public function set content(value:Sprite):void
		{
			_content=value;
		}
		public function get content():Sprite
		{
			return _content;
		}
		public override function set width(value:Number):void
		{
			_width=value;
			updataSizeNextRend=true;
		}
		public override function set height(value:Number):void
		{
			_height=value;
			updataSizeNextRend=true;
		}
		public override function dispose():void
		{
			super.dispose();
			bitmapData.dispose();
		}
		public function set smoothing(value:Boolean):void
		{
			bitmap.smoothing=value;	
		}
		public function get smoothing():Boolean
		{
			return bitmap.smoothing;
		}
		protected function set bitmapData(value:BitmapData):void
		{
			_bitmapData.dispose();
			_bitmapData=value;
			bitmap.bitmapData=value;
			bitmap.smoothing=smoothing;
		}
		protected function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		/**
		 *	绘制content至位图 
		 * 
		 */		
		protected override function onRend():void
		{
			updataSize();
			if(drawNew)
			{
				bitmapData.fillRect(bitmapData.rect,fillColor);
			}
			drawContent();
			super.onRend();
		}
		private function updataSize():void
		{
			if(updataSizeNextRend)
			{
				var isSmoothing:Boolean=bitmap.smoothing;
				var newBitmapdata:BitmapData=new BitmapData(_width,_height,transparent,fillColor);
				newBitmapdata.copyPixels(bitmapData,bitmapData.rect,new Point());
				bitmapData=newBitmapdata;
				dispatchEvent(new Event(DisplayEvent.SIZE_UPDATA));
				updataSizeNextRend=false;
			}
		}
		private function drawContent():void
		{
			var mat:Matrix=new Matrix();
			//mat.translate(_content.width,_content.height)
			bitmapData.draw(_content, mat , null, blendModeOnDraw, clipRect, smoothing);
		}
		
	}
}
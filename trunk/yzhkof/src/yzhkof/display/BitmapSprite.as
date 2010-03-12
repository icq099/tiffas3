package yzhkof.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class BitmapSprite extends RenderSprite
	{
		protected var bitmapData:BitmapData;
		protected var _content:Sprite=new Sprite;
		protected var drawNew:Boolean=true;
		protected var fillColor:uint;
		protected var transparent:Boolean;
		protected var updataSizeNextRend:Boolean=false;
		
		private var bitmap:Bitmap;
		private var _width:Number;
		private var _height:Number;
		public function BitmapSprite(width:Number,height:Number,transparent:Boolean=true,fillColor:uint=0)
		{
			super();
			this.drawNew=drawNew;
			this.fillColor=fillColor;
			this.transparent=transparent;
			_width=width;
			_height=height;
			this.bitmapData=new BitmapData(width,height,transparent,fillColor);
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
			_width=width;
			updataSizeNextRend;
		}
		public override function set height(value:Number):void
		{
			_height=height;
			updataSizeNextRend;
		}
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
				var newBitmapdata:BitmapData=new BitmapData(_width,_height,transparent,fillColor);
				newBitmapdata.copyPixels(bitmapData,bitmapData.rect,new Point());
				bitmapData.dispose();
				bitmap.bitmapData=newBitmapdata;
			}
			updataSizeNextRend=false;
		}
		private function drawContent():void
		{
			var mat:Matrix=new Matrix();
			//mat.translate(_content.width,_content.height)
			bitmapData.draw(_content, mat , null, null, bitmapData.rect, false);
		}
		
	}
}
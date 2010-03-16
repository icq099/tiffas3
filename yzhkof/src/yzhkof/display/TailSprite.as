package yzhkof.display
{
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yzhkof.debug.traceObject;
	import yzhkof.display.event.DisplayEvent;
	
	public class TailSprite extends BitmapSprite
	{
		public var blurFilter:BlurFilter=new BlurFilter(10,10);
		public var colorTransForm:ColorTransform=new ColorTransform(1,1,1,1,0,0,0,-1);
		public var filterSlef:Boolean=false;
		
		private var _xOffset:Number=0;
		private var _yOffset:Number=0;
		private var upDataClipRectNextRend:Boolean=false;
		
		public function TailSprite(width:Number, height:Number, transparent:Boolean=true, fillColor:uint=0)
		{
			super(width, height, transparent, fillColor);
			drawNew=false;
			addEventListener(DisplayEvent.SIZE_UPDATA,onSizeUpdata);
		}
		public function set xOffset(value:Number):void
		{
			_xOffset=value;
			upDataClipRectNextRend=true;
		}
		public function get xOffset():Number
		{
			return _xOffset;
		}
		public function set yOffset(value:Number):void
		{
			_yOffset=value;
			upDataClipRectNextRend=true;
		}
		public function get yOffset():Number
		{
			return _yOffset;
		}
		protected override function onRend():void
		{
							
			if(blurFilter)
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),blurFilter);
//				{
//					var nb:BitmapData=new BitmapData(width,height,true,fillColor)
//					nb.applyFilter(bitmapData,bitmapData.rect,new Point(),blurFilter);
//					bitmapData=nb;
//				}
			if(colorTransForm)
				bitmapData.colorTransform(bitmapData.rect,colorTransForm);
			if((xOffset!=0)||(yOffset!=0))
			{
				bitmapData.scroll(xOffset,yOffset);
				if(xOffset!=0)
					bitmapData.fillRect(new Rectangle(xOffset>0?0:(bitmapData.width+xOffset),0,Math.abs(xOffset),bitmapData.height),fillColor);
				if(yOffset!=0)
					bitmapData.fillRect(new Rectangle(0,yOffset>0?0:(bitmapData.height+yOffset),bitmapData.width,Math.abs(yOffset)),fillColor);
			}	
			
			super.onRend();
			
			if(filterSlef)
				if(blurFilter)
					bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),blurFilter);
				
			if(upDataClipRectNextRend)
				updataClip();
		}
		private function updataClip():void
		{
			clipRect=new Rectangle(xOffset>0?xOffset:0,yOffset>0?yOffset:0,bitmapData.width-Math.abs(xOffset),bitmapData.height-Math.abs(yOffset));
			upDataClipRectNextRend=false;
		}
		private function onSizeUpdata(e:Event):void
		{
			updataClip();
		}
	}
}
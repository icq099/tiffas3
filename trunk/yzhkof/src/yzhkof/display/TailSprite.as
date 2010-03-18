package yzhkof.display
{
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yzhkof.display.event.DisplayEvent;
	
	public class TailSprite extends BitmapSprite
	{
		public var blurFilter:BlurFilter=new BlurFilter(10,10);
		public var colorTransForm:ColorTransform=new ColorTransform(1,1,1,1,0,0,0,0);
		public var filterSlef:Boolean=false;
		
		private var _offset:Point=new Point();
		private var upDataClipRectNextRend:Boolean=false;
		
		public function TailSprite(width:Number, height:Number, transparent:Boolean=true, fillColor:uint=0)
		{
			super(width, height, transparent, fillColor);
			drawNew=false;
			addEventListener(DisplayEvent.SIZE_UPDATA,onSizeUpdata);
		}
		public function set offset(value:Point):void
		{
			if((value.x!=_offset.x)||(value.y!=_offset.y)){
				_offset=value;
				upDataClipRectNextRend=true;
			}
		}
		public function get offset():Point
		{
			return _offset;
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
			if((_offset.x!=0)||(_offset.y!=0))
			{
				bitmapData.scroll(_offset.x,_offset.y);
				if(_offset.x!=0)
					bitmapData.fillRect(new Rectangle(_offset.x>0?0:(bitmapData.width+_offset.x),0,Math.abs(_offset.x),bitmapData.height),fillColor);
				if(_offset.y!=0)
					bitmapData.fillRect(new Rectangle(0,_offset.y>0?0:(bitmapData.height+_offset.y),bitmapData.width,Math.abs(_offset.y)),fillColor);
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
			clipRect=new Rectangle(_offset.x>0?_offset.x:0,_offset.y>0?_offset.y:0,bitmapData.width-Math.abs(_offset.x),bitmapData.height-Math.abs(_offset.y));
			upDataClipRectNextRend=false;
		}
		private function onSizeUpdata(e:Event):void
		{
			updataClip();
		}
	}
}
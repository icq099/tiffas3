package yzhkof.display
{
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	public class TailSprite extends BitmapSprite
	{
		public var blurFilter:BlurFilter=new BlurFilter(10,10);
		public function TailSprite(width:Number, height:Number, transparent:Boolean=true, fillColor:uint=0)
		{
			super(width, height, transparent, fillColor);
			drawNew=false;
		}
		protected override function onRend():void
		{
			bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),blurFilter);
			super.onRend();
		}
		
	}
}
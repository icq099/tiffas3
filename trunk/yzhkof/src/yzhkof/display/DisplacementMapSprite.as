package yzhkof.display
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class DisplacementMapSprite extends TailSprite
	{
		private var maskBitmapdata:BitmapData;
		private var filter:DisplacementMapFilter;
		public function DisplacementMapSprite(width:Number, height:Number, transparent:Boolean=true, fillColor:uint=0)
		{
			super(width, height, transparent, fillColor);
			//drawNew=false;
			yOffset=-5;
			maskBitmapdata=new BitmapData(width,height);
			filter = new DisplacementMapFilter(maskBitmapdata,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		}
		protected override function onRend():void
		{
			maskBitmapdata.perlinNoise(16, 16, 1, getTimer(), false, true, BitmapDataChannel.RED | BitmapDataChannel.GREEN, false, [new Point(0,-4)]);
			bitmapData.applyFilter(bitmapData,clipRect,new Point(),filter);
			super.onRend();
		}
		
	}
}
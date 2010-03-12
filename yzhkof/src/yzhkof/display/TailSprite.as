package yzhkof.display
{
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class TailSprite extends BitmapSprite
	{
		public var blurFilter:BlurFilter=new BlurFilter(10,10);
		public var colorTransForm:ColorTransform=new ColorTransform(1,1,1,1,0,0,0,-1);
		public var filterSlef:Boolean=false;
		public var xOffset:Number=0;
		public var yOffset:Number=0;	
		public function TailSprite(width:Number, height:Number, transparent:Boolean=true, fillColor:uint=0)
		{
			super(width, height, transparent, fillColor);
			drawNew=false;
		}
		protected override function onRend():void
		{
			if(filterSlef)
				super.onRend();
				
			if(blurFilter)
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),blurFilter);
			if(colorTransForm)
				bitmapData.colorTransform(bitmapData.rect,colorTransForm);
			if((xOffset!=0)||(yOffset!=0))
				bitmapData.scroll(xOffset,yOffset);		
				
			if(!filterSlef)
				super.onRend();
		}
		
	}
}
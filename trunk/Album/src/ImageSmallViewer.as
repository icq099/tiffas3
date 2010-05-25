package
{
	import flash.events.Event;
	
	public class ImageSmallViewer extends ImageViewer
	{
		protected const GAP:Number=10;
		
		public function ImageSmallViewer(data:PhotoData)
		{
			urlDataOn = "smallUrl";
			super(data);
			WIDTH=150;
			HEIGHT=100;
			updataDisplay();
		}
		protected override function updataDisplay():void
		{
			super.updataDisplay();
			
			loader.x=GAP;
			loader.y=GAP;
			
		}
		protected override function __onComplete(e:Event):void
		{
			super.__onComplete(e);
			loader.width=WIDTH-GAP*2;
			loader.height=HEIGHT-GAP*2;
		}
	}
}
package lsd.myview
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MapChangeEvent extends Event
	{  
		public static const MAPCHANGEVENT:String="mapchangevent";
		public  var sprite:Sprite;
		
		public function MapChangeEvent(type:String,sprite:Sprite) 
		{
			this.sprite=sprite;
			super(type);
		}

	}
}
package util.loaders
{
	import flash.events.Event;

	public class SerialSwfLoaderEvent extends Event
	{
		public static var ITEM_COMPLETE:String="SerialSwfLoaderEvent.ITEM_COMPLETE";
		public static var ALL_COMPLETE:String="SerialSwfLoaderEvent.ALL_COMPLETE";
		public static var PROGRESS:String="SerialSwfLoaderEvent.PROGRESS";
		public var byteLoaded:Number=0;
		public var byteTotal:Number=0;
		public function SerialSwfLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
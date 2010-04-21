package loaders.event
{
	import flash.events.Event;

	public class SerialXmlLoaderEvent extends Event
	{
		public static const INIT:String="SerialXmlLoaderEvent.INIT";//开始加载
		public static const ITEMCOMPLETE:String="SerialXmlLoaderEvent.ITEMCOMPLETE";//一部分加载完毕
		public static const ALLCOMPLETE:String="SerialXmlLoaderEvent.ALLCOMPLETE";//全部加载完毕
		public static const IOERROR:String="SerialXmlLoaderEvent.IOERROR";//全部加载完毕
		public var id:String;
		public function SerialXmlLoaderEvent(type:String,id:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package view.leftupmenu.Event
{
	import flash.events.Event;

	public class LeftUpMenuEvent extends Event
	{
		public static const ITEM_CLICK:String="ITEM_CLICK";
		public static const GO_CLICK:String="GO_CLICK";
		public var id:String;
		public var go:int;
		
		public function LeftUpMenuEvent(type:String,id:String=null,go:int=-1, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.id=id;
			this.go=go;
		}
		
	}
}
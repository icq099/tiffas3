package lxfa.gehaiqingyun.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PlayListButton extends Sprite
	{
		public var label:String;
		public var icon:String=null;
		public function PlayListButton(path:String,name:String)
		{
			label=name;
		}
	}
}
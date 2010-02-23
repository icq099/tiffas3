package lxfa.particle
{
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	
	public class Particle extends Sprite
	{
		public function Particle()
		{
			var guiwa:GuiWaSwc=new GuiWaSwc();
			guiwa.y=200;
			guiwa.x=200;
			var comming:GuiWaCommingSwc=new GuiWaCommingSwc();
			this.addChild(guiwa);
			this.addChild(comming);
		}
	}
}
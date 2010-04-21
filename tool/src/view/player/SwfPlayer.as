package view.player
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.controls.SWFLoader;
	
	public class SwfPlayer extends SWFLoader
	{
		private var path:String
		private var swfWidth:int;
		private var swfHeight:int;
		public function SwfPlayer(path:String,width:int,height:int)
		{
			super();
			this.path=path;
			this.width=width;
			this.height=height;
			this.maintainAspectRatio=false;//关键
			this.scaleContent=false;//关键
			this.load(path);
		}
		public function dispose():void
		{
			this.unloadAndStop();
		}
	}
}
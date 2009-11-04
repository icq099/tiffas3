package yzhkof.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class NormalLoaderItem extends LoaderBase
	{
		public function NormalLoaderItem()
		{
			super(new Loader());
			currentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			currentLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onComplete);
		}
		public override function start(value:Object=null):void{
			currentLoader.load(new URLRequest((String(value))));
			super.start();
		}
		public override function pause():void{
			try{
				currentLoader.close();
			}catch(e:Error){
			}
			super.pause();
		}
		public override function resume():void{
			if(!isLoading){
				currentLoader.load(new URLRequest(String(_url)));
				super.resume();
			}
		}
		public override function unload():void{
			currentLoader.unload();
			super.unload();
		}
		private function get currentLoader():Loader{
			return loader as Loader
		}
		
	}
}
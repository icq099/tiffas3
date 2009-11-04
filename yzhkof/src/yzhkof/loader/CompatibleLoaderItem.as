package yzhkof.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class CompatibleLoaderItem extends LoaderBase
	{
		public function CompatibleLoaderItem()
		{
			super(new CompatibleLoader());
			currentLoader.addEventListener(Event.COMPLETE,onComplete);
			currentLoader.addEventListener(IOErrorEvent.IO_ERROR,onComplete);
		}
		public override function start(value:Object=null):void{
			currentLoader.load(value);
			super.start();
		}
		public override function resume():void{
			if(!isLoading){
				currentLoader.load(_url);
				super.resume();
			}
		}
		public override function unload():void{
			currentLoader.unload();
			super.unload();
		}
		public override function pause():void{
			try{
				currentLoader.close();
			}catch(e:Error){
			}
			super.pause();
		}
		private function get currentLoader():CompatibleLoader{
			return loader as CompatibleLoader;
		}
		
	}
}
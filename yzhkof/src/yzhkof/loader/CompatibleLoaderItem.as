package yzhkof.loader
{
	import flash.events.Event;
	
	public class CompatibleLoaderItem extends LoaderBase
	{
		public function CompatibleLoaderItem()
		{
			super(new CompatibleLoader());
			currentLoader.addEventListener(Event.COMPLETE,onComplete);
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
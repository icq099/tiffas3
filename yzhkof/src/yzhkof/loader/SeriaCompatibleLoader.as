package yzhkof.loader
{
	import flash.events.Event;
	
	public class SeriaCompatibleLoader extends SerialLoaderBase
	{
		public function SeriaCompatibleLoader()
		{
			super(CompatibleLoader);
		}
		public override function start():void{
			super.start();
			for(var i:int=0;i<url_arr.length;i++){
				var loader:CompatibleLoader=getLoader(url_arr[i]);
				loader.load(url_arr[i]);
				loader.addEventListener(Event.COMPLETE,onLoaderComplete);
			}	
		}
		public override function stopAll():void{
			super.stopAll();
			for(var i:int=0;i<url_arr.length;i++){
				var loader:CompatibleLoader=getLoader(url_arr[i]);
				loader.unloadAndStop();
			}	
		}
		protected override function onLoaderComplete(e:Event):void{
			item_map[loader_url_map.getKey(e.currentTarget)]=CompatibleLoader(e.currentTarget).content;
			super.onLoaderComplete(e);
		}
		private function getLoader(url:Object):CompatibleLoader{
			return loader_url_map.getValue(url) as CompatibleLoader;
		}
		
	}
}
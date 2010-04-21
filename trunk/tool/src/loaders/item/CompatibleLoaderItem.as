package loaders.item
{
	import loaders.proxy.CompatibleLoaderProxy;
	
	public class CompatibleLoaderItem extends LoaderBaseItem
	{
		public function CompatibleLoaderItem()
		{
			super(new CompatibleLoaderProxy);
		}
		public override function start(value:Object=null):void{
			currentLoader.manageStart(value);
			super.start();
		}
		public override function resume():void{
			if(!isLoading){
				currentLoader.manageResume(_url);
				super.resume();
			}
		}
		public override function unload():void{
			currentLoader.manageUnload();
			super.unload();
		}
		public override function pause():void{
			try{
				currentLoader.managePause();
			}catch(e:Error){
			}
			super.pause();
		}
		private function get currentLoader():CompatibleLoaderProxy{
			return _loader as CompatibleLoaderProxy;
		}
		
	}
}
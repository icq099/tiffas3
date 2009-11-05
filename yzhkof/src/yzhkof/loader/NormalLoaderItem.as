package yzhkof.loader
{
	import yzhkof.loader.proxy.NormalLoaderProxy;
	
	public class NormalLoaderItem extends LoaderBaseItem
	{
		public function NormalLoaderItem()
		{
			super(new NormalLoaderProxy());
		}
		public override function start(value:Object=null):void{
			currentLoader.manageStart(value);
			super.start();
		}
		public override function pause():void{
			currentLoader.managePause();
			super.pause();
		}
		public override function resume():void{
			if(!isLoading){
				currentLoader.manageResume(_url);
				super.resume();
			}
		}
		public override function unload():void{
			currentLoader.manageUnload()
			super.unload();
		}
		public override function unLoadAndStop(gc:Boolean=true):void{
			currentLoader.manageUnloadAndStop(gc);
			super.unload();
		}
		private function get currentLoader():NormalLoaderProxy{
			return _loader as NormalLoaderProxy
		}
		
	}
}
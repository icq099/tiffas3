package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;

	public class Testloader extends Loader
	{
		private var _loaderinfo:LoaderInfo
		public function Testloader()
		{
			super();
		}
		public function setloder(l:LoaderInfo):void{
			_loaderinfo=l;
		}
		public override function get loaderInfo():LoaderInfo{
			return _loaderinfo;
		} 
		
	}
}
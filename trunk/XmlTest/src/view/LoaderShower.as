package view
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import mx.core.UIComponent;
	
	import yzhkof.loader.CompatibleLoader;

	public class LoaderShower extends UIComponent
	{
		private var loader:CompatibleLoader=new CompatibleLoader();
		private var _source:Object;
		public function LoaderShower()
		{
			super();
			measuredWidth=320;
			measuredHeight=240;
			addChild(loader);
		}
		public function set source(value:Object):void{
			_source=value;
			if(_source!=null) loader.unloadAndStop(true);
			loader.load(_source,new LoaderContext(false,ApplicationDomain.currentDomain));
		}
		public function get source():Object{
			return _source;
		}
		public function unloadAndStop(gc:Boolean=true):void{
			loader.unloadAndStop(gc)
		}
		
	}
}
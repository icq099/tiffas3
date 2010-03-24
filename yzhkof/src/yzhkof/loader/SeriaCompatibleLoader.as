package yzhkof.loader
{
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	public class SeriaCompatibleLoader extends SerialLoaderBase
	{
		public function SeriaCompatibleLoader(loaderContext:LoaderContext=null)
		{
			var param:Array=new Array;
			if(loaderContext!=null)
				param.push(loaderContext);
			super(CompatibleLoader,"load",null,Event.COMPLETE,"unloadAndStop","content",param);
		}
	}
}
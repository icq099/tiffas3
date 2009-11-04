package yzhkof.loader
{
	import yzhkof.util.HashMap;

	internal class LoaderMap extends HashMap
	{
		public function LoaderMap()
		{
		}
		public function getLoaderBase(key:Object):LoaderBase{
			return getValue(key) as LoaderBase
		}
		public override function put(key:Object, value:Object):Object{
			return super.put(key,value as LoaderBase);
		}
		
	}
}
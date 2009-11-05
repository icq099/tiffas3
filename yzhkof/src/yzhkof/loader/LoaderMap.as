package yzhkof.loader
{
	import yzhkof.util.HashMap;

	internal class LoaderMap extends HashMap
	{
		public function LoaderMap()
		{
		}
		public function getLoaderBase(key:Object):LoaderBaseItem{
			return getValue(key) as LoaderBaseItem
		}
		public override function put(key:Object, value:Object):Object{
			return super.put(key,value as LoaderBaseItem);
		}
		
	}
}
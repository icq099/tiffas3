package structure
{
	import flash.utils.Dictionary;
	/* 只要有key就可以获得value，只要有value就可以获得key */
	public class DualMap
	{
		private var key_map:Dictionary=new Dictionary(true);
		private var value_map:Dictionary=new Dictionary(true);
		public function DualMap()
		{
		}
		public function put(key:Object,value:Object):void{
			key_map[key]=value;
			value_map[value]=key;
		}
		public function getValue(key:Object):Object{
			if(key_map[key]!=undefined){
				return key_map[key];
			}
			return null;
		}
		public function getKey(value:Object):Object{
			if(value_map[value]!=undefined){
				return value_map[value];
			}
			return null;
		}
		public function remove(key:Object):void{
			delete value_map[key_map[key]];
			delete key_map[key];
		}
		public function clear():void
		{
			key_map=null;
			value_map=null;
		}
	}
}
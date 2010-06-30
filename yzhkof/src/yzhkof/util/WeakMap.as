package yzhkof.util
{
	import flash.utils.Dictionary;
	
	public class WeakMap
	{
		private var map:Dictionary=new Dictionary(true);
		private var key_set:Array=new Array;
		private var _length:int=0;
		public function WeakMap()
		{
			
		}
		public function get length():int
		{
			return _length;
		}
		public function get keySet():Array
		{
			return key_set;
		}
		public function get valueSet():Array
		{
			var re_arr:Array=new Array;
			for (var i:* in map)
			{
				re_arr.push(i);
			}
			return re_arr;
		}
		public function contentValue(value:*):Boolean
		{
			for (var i:* in map)
			{
				if(i == value)
				{
					return true;
				}
			}
			return false;
		}
		public function contentKey(key:*):Boolean
		{
			var key_arr:Array=keySet;
			for each(var i:* in key_arr)
			{
				if(i==key)
				{
					return true;
				}
			}
			return false;
		
		}
		public function add(key:*,value:*):void
		{
			//如果键存在，删除键
			if(contentKey(key))
			{
				for each(var i:Array in map)
				{
					i.splice(i.indexOf(key),1);
				}
				_length--;
			}
			//如果值存在
			if(contentValue(value))
			{
				//增加指向值的键
				map[value].push(key);
			}
			else
			{
				//指向值的键
				map[value]=[key];
			}
			_length++
			
			if(key_set.indexOf(key)<0)
			{
				key_set.push(key);
			}
		}
		public function getValue(key:*):*
		{
			// i 为值
			for (var i:* in map)
			{
				// 指向 i 的键
				var key_arr:Array=map[i];
				for each(var k:* in key_arr)
				{
					if(k == key)
					{
						return i;
					}
				}
			}
			return null;
		}
		public function remove(key:*):void
		{
			var value:*=getValue(key);
			var key_arr:Array=map[getValue(key)];
			if(key_arr)
			{
				key_arr.splice(key_arr.indexOf(key),1);
				if(key_arr.length<=0)
				{
					delete map[value];
				}
				_length--;
			}
			key_set.splice(key_set.indexOf(key),1);
		}

	}
}
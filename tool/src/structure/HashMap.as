package structure
{
	import flash.utils.Dictionary;
	
	public class HashMap
	{
		private var _key:Array=new Array();
		private var _value:Dictionary;
		private var _length:int=0;
		private var weekkeys:Boolean;
		public function HashMap(weekkeys:Boolean=true)
		{
			_value=new Dictionary(weekkeys);
			this.weekkeys=weekkeys;
		}
		//存入数据
		public function put(key:Object,value:Object):Object{
			if(!containsKey(key)){
				_key.push(key);
				_value[key]=value;
				_length++;
				return null
			}
			return _value[key]=value;
		}
		//是否存在指定的key
		public function containsKey(key:Object):Boolean{
			if(_value[key]==undefined) return false;
			return true;
		}
		//是否存在指定的对象
		public function containsValue(value:Object):Boolean{
			for(var i:int=0;i<_length;i++){
				if(_value[_key[i]]==value) return true;
			}
			return false;
		}
		//删除指定对象在列表中的数据
		public function remove(key:Object):Object{
			if(containsKey(key)){
				var result:Object=_value[key];
				_key.splice(_key.indexOf(key),1);
				delete _value[key];
				_length--;
				return result;
			}
			return null;
		}
		//根据key获取对象
		public function getValue(key:Object):Object{
			if(_value[key]!=undefined) return _value[key];
			return null;
		}
		//获取列表的长度
		public function get size():int{
			return _length;
		}
		public function get isEmpty():Boolean{
			return _length>0?false:true;
		}
		public function get keySet():Array{
			return new Array().concat(_key);
		}
		public function get valueSet():Array{
			var re_array:Array=new Array();
			for each(var i:Object in _key){
				re_array.push(_value[i]);
			}
			return re_array;
		}
		//清楚整个hashmap
		public function clear():void{
			_key=new Array();
			_value=new Dictionary(weekkeys);
			_length=0;
		}
	}
}
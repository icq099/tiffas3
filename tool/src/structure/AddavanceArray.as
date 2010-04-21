package structure
{
	
	public class AddavanceArray
	{
		public var index:int=0;
		private var array:Array=new Array;
		public var length:int=0;
		public function AddavanceArray()
		{
		}
		public function push(obj:*):void
		{
			length++;
			array.push(obj);
		}
		public function getValue(id:int):*
		{
			return array[id];
		}
		public function dispose():void
		{
			array=null;
		}
	}
}
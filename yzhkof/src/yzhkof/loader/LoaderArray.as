package yzhkof.loader
{
	import mx.events.IndexChangedEvent;
	
	public dynamic class LoaderArray extends Array
	{
		public function LoaderArray(numElements:int=0)
		{
			super(numElements);
		}
		AS3 override function concat(...args):Array{
			var re_arry:LoaderArray=new LoaderArray();
			for each(var i:* in args){
				re_arry.push(i);
			}
			return re_arry;
		}
		public function putToFirstByIndex(index:int):void{
			super.unshift(super.splice(index,1)[0]);
		}
		public function putToFirst(searchElement:Object):void{
			putToFirstByIndex(super.indexOf(searchElement));
		}		
	}
}
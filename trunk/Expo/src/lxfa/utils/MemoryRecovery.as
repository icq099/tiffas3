package lxfa.utils
{
	public class MemoryRecovery
	{
		private static var instance:MemoryRecovery
		public function MemoryRecovery()
		{
			if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("不能实例化");
			}
		}
		public static function getInstance():MemoryRecovery
		{
			if(instance==null) return new MemoryRecovery();
			return instance;
		}
		//回收对象
		public function gcObj(obj:*,hasDispose:Boolean=false):void
		{
			if(obj!=null)
			{
				if(hasDispose)
				{
					obj.dispose();
				}
				if(obj.parent!=null)
				{
					obj.parent.removeChild(obj);
				}
				obj=null;
			}
		}
		//回收事件
		public function gcFun(obj:*,eventname:String,fun:Function):void
		{
			if(obj!=null)
			{
				if(obj.hasEventListener(eventname))
				{
					obj.removeEventListener(eventname,fun);
				}
			}
		}
	}
}
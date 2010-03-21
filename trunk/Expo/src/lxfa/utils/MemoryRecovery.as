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
		public function gc(obj:*,hasDispose:Boolean=false):void
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
	}
}
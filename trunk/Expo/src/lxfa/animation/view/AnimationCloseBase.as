package lxfa.animation.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AnimationCloseBase extends AnimationClose
	{
		private static var instance:AnimationCloseBase
		public function AnimationCloseBase()
		{
			if(instance==null)
			{
				super();
				instance=this;
			}else
			{
				throw new Error("不能实例化关闭按钮");
			}
		}
		public static function getInstance():AnimationCloseBase
		{
			if(instance==null) instance=new AnimationCloseBase();
			return instance;
		}
		public function hide():void
		{
			if(instance.parent!=null)
			{
				instance.parent.removeChild(instance);
			}
		}
	}
}
package lxfa.animation.view
{
	public class AnimationGetOutBase extends AnimationOut
	{
		private static var instance:AnimationGetOutBase;
		public function AnimationGetOutBase()
		{
			if(instance==null){
				super();
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():AnimationGetOutBase
		{
			if(instance==null) instance=new AnimationGetOutBase();
			return instance;
		}
		public function hide():void
		{
			instance.stop();
			if(instance.parent!=null)
			{
				instance.parent.removeChild(instance);
			}
		}
	}
}
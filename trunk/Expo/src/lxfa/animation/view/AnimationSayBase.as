package lxfa.animation.view
{
	public class AnimationSayBase extends AnimationSay
	{
		private static var instance:AnimationSayBase;
		public function AnimationSayBase()
		{
			if(instance==null){
				super();
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():AnimationSayBase
		{
			if(instance==null) instance=new AnimationSayBase();
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
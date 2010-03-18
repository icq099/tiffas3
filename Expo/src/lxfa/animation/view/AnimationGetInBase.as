package lxfa.animation.view
{
	import communication.MainSystem;
	
	public class AnimationGetInBase extends AnimationIn
	{
		private static var instance:AnimationGetInBase;
		public function AnimationGetInBase()
		{
			if(instance==null){
				super();
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():AnimationGetInBase
		{
			if(instance==null) instance=new AnimationGetInBase();
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
		public function reStart():void
		{
			instance.stop();
			instance.gotoAndPlay(0);
		}
	}
}
package lxfa.animation.view
{
	public class AnimationSayTextBase extends SayText
	{
		private static var instance:AnimationSayTextBase;
		public function AnimationSayTextBase()
		{
			if(instance==null)
			{
				super();
				instance=this;
				this.visible=false;
			}else
			{
				throw new Error("不能实例化");
			}
		}
		public static function getInstance():AnimationSayTextBase
		{
			if(instance==null) instance=new AnimationSayTextBase();
			return instance;
		}
		public function hide():void
		{
			if(instance.parent!=null)
			{
				instance.parent.removeChild(instance);
			}
		}
		public function setText(text:String):void
		{
			instance.text.text=text;
		}
	}
}
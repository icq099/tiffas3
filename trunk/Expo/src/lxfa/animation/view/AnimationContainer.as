package lxfa.animation.view
{
	import mx.core.UIComponent;
	
	public class AnimationContainer extends UIComponent
	{
		private static var instance:AnimationContainer;
		public function AnimationContainer()
		{
			if(instance==null){
				super();
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():AnimationContainer
		{
			if(instance==null) instance=new AnimationContainer();
			return instance;
		}
	}
}
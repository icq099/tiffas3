package yzhkof.effect
{
	import mx.core.UIComponent;
	
	import yzhkof.util.HashMap;
	
	public class MyEffect
	{
		public function MyEffect()
		{
		}
		public static function addChild(effect:EffectBase):void{
			effect.container.addChild(effect.effector);
			effect.effector.visible=false;
			if(effect.effector is UIComponent){
				UIComponent(effect.effector).validateNow();
			}
			doEffect(effect,function():void{
				effect.effector.visible=true;
			});
		}
		public static function removeChild(effect:EffectBase):void{
			effect.container.removeChild(effect.effector);
			doEffect(effect);
		}
		private static function doEffect(effect:EffectBase,onComplete:Function=null):void{
			effect.onEffectComplete=onComplete;
			effect.start();
		}
	}
}
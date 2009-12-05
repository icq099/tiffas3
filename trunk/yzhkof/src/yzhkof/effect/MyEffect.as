package yzhkof.effect
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class MyEffect
	{
		public function MyEffect()
		{
		}
		public static function addChild(effect:EffectBase):void{
			var doFun:Function=function():void{
				doEffect(effect,function():void{
					effect.effector.visible=true;
				});
				if(effect.effector is UIComponent){
					UIComponent(effect.effector).removeEventListener(FlexEvent.UPDATE_COMPLETE,doFun);
				}
			}
			if(effect.effector is UIComponent){
				UIComponent(effect.effector).addEventListener(FlexEvent.UPDATE_COMPLETE,doFun);
			}else{
				doFun();
			}
			effect.container.addChild(effect.effector);
			effect.effector.visible=false;
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
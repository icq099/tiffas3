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
			}
			effect.container.addChild(effect.effector);
			effect.effector.visible=false;
			if(effect.effector is UIComponent){
				effect.effector.addEventListener(FlexEvent.CREATION_COMPLETE,doFun);
			}else{
				doFun();
			}
		}
		public static function removeChild(effect:EffectBase):void{
			effect.effector.visible=false;
			doEffect(effect,function():void{
				effect.container.removeChild(effect.effector);
			});
		}
		private static function doEffect(effect:EffectBase,onComplete:Function):void{
			effect.onEffectComplete=onComplete;
			effect.start();
		}
	}
}
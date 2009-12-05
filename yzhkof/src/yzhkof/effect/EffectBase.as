package yzhkof.effect
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mx.core.FlexSprite;
	
	public class EffectBase
	{
		protected var _onEffectComplete:Function;
		protected var _container:DisplayObjectContainer;//效果的容器
		protected var _effector:DisplayObject;//效果的发起者
		protected var isFlex:Boolean;//container是否为flex组件;
		public function EffectBase(container:DisplayObjectContainer,effector:DisplayObject)
		{
			_container=container;
			_effector=effector;
			_container is FlexSprite?isFlex=true:isFlex=false;
		}
		public function start():void{
			onEffectStart();
		}
		protected function onEffectStart():void{
		}
		public function set onEffectComplete(value:Function):void{
			_onEffectComplete=value;
		}
		public function get onEffectComplete():Function{
			return _onEffectComplete!=null?_onEffectComplete:function():void{};
		}
		public function get container():DisplayObjectContainer{
			return _container;
		}
		public function get effector():DisplayObject{
			return _effector;
		}
	}
}
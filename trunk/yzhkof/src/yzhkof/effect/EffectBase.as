package yzhkof.effect
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
//	import mx.core.FlexSprite;
	
	import yzhkof.util.HashMap;
	
	public class EffectBase
	{
		protected static const effector_map:HashMap=new HashMap();//<displayObject,EffectBase>
		protected var _onEffectComplete:Function;
		protected var _container:DisplayObjectContainer;//效果的容器
		protected var _effector:DisplayObject;//效果的发起者
		protected var isFlex:Boolean;//container是否为flex组件;
		public function EffectBase(container:DisplayObjectContainer,effector:DisplayObject)
		{
			_container=container;
			_effector=effector;
//			_container is FlexSprite?isFlex=true:isFlex=false;
		}
		public function start():void{
			if(effector_map.containsKey(effector)){
				EffectBase(effector_map.getValue(effector)).cancel();
			}
			effector_map.put(effector,this);
			onEffectStart();
		}
		/**
		 * 当效果结束时手动触发; 
		 * 
		 */		
		public function cancel():void{
			effector_map.remove(effector);
			onEffectComplete();
		}
		//当效果开始时触发;
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
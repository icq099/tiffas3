package yzhkof.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import yzhkof.display.render.RenderDispatcher;
	import yzhkof.display.render.RenderEngineBasic;
	import yzhkof.display.render.event.RenderEvent;

	public class RenderSprite extends Sprite
	{
		private var _engineSelf:RenderEngineBasic;
		public function RenderSprite()
		{
			super();
			setRenderDefault();
		}
		public function set engineSelf(value:RenderEngineBasic):void
		{
			removeDefaultRender();
			removeSelfRenderListener();
			_engineSelf=value;
			setSelfRenderListener();
		}
		public function get engineSelf():RenderEngineBasic
		{ 
			return _engineSelf;
		}
		/**
		 *	当渲染时调用 
		 * 
		 */		
		protected function onRend():void
		{
			
		}
		public function setRenderDefault():void
		{
			RenderDispatcher.getInstance().addEventListener(RenderEvent.ON_REND,onRendDefault,false,0,true);
		}
		private function removeDefaultRender():void
		{
			RenderDispatcher.getInstance().removeEventListener(RenderEvent.ON_REND,onRendDefault);
		}
		private function setSelfRenderListener():void
		{
			if(_engineSelf)
			{
				_engineSelf.addEventListener(RenderEvent.ON_REND,onRendSelf);
			}
		}
		private function removeSelfRenderListener():void
		{
			_engineSelf.removeEventListener(RenderEvent.ON_REND,onRendSelf);
		}
		private function onRendSelf(e:Event):void
		{
			onRend();
		}
		private function onRendDefault(e:Event):void
		{
			onRend();
		}
		
	}
}
package yzhkof.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import yzhkof.display.render.RenderDispatcher;
	import yzhkof.display.render.RenderEngineBasic;
	import yzhkof.display.render.event.RenderEvent;

	public class RenderSprite extends Sprite
	{
		/**
		 *	是否只在stage不为null时渲染 
		 */		
		public var rendAtStage:Boolean=false;
		
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
		/**
		 *	停止所有渲染 
		 * 
		 */		
		public function dispose():void
		{
			removeDefaultRender();
			removeSelfRenderListener();
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
			if(_engineSelf)
			{
				_engineSelf.removeEventListener(RenderEvent.ON_REND,onRendSelf);
			}
		}
		private function onRending():void
		{
			if(rendAtStage)
			{
				if(stage!=null)
					onRend();
			}
			else
			{
				onRend();	
			}
		}
		private function onRendSelf(e:Event):void
		{
			onRending();
		}
		private function onRendDefault(e:Event):void
		{
			onRending();
		}
		
	}
}
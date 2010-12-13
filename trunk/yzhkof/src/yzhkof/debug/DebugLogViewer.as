package yzhkof.debug
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.ui.DragPanel;
	import yzhkof.ui.ScrollPanel;
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.ui.event.ComponentEvent;
	import yzhkof.util.WeakMap;
	
	public class DebugLogViewer extends DragPanel
	{
		private var _logArr:Array = [];
		private var _logMap:Dictionary = new Dictionary;
		private var _logWeakMap:WeakMap = new WeakMap;
		private var log_max_count:uint = 2000;
		
		private var scrollPanel:ScrollPanel = new ScrollPanel;
		private var tileContainer:TileContainer = new TileContainer;
		private var btn_Container:TileContainer = new TileContainer;
		private var clean_btn:TextPanel = new TextPanel(0xffff00);
		private var start_btn:TextPanel = new TextPanel(0xffff00);
		private var stop_btn:TextPanel = new TextPanel(0xffff00);
		private var start_stop_container:Sprite = new Sprite;
		
		private var isStart:Boolean = true;
		private var _weak:Boolean = false;
		
		public function DebugLogViewer(weak:Boolean = false)
		{
			super();
			_weak = weak;
			init();
			initEvent();
		}
		private function init():void
		{
			_content.addChild(scrollPanel);
			_content.addChild(btn_Container);
			
			clean_btn.text = "清除";
			start_btn.text = "开始";
			stop_btn.text = "停止";
			
			start_stop_container.addChild(start_btn);
			start_stop_container.addChild(stop_btn);
			start_btn.visible = false;
			
			btn_Container.appendItem(clean_btn);
			btn_Container.appendItem(start_stop_container);
			
			scrollPanel.source = tileContainer;
			scrollPanel.y = 20;
			scrollPanel.width = 500;
			scrollPanel.height = 400;
			tileContainer.width = scrollPanel .width - 10;
			scrollPanel.addEventListener(ComponentEvent.DRAW_COMPLETE,__createComplete);
		}
		private function initEvent():void
		{
			clean_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				cleanLog();
			});
			start_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				isStart = true;
				start_btn.visible = !start_btn.visible;
				stop_btn.visible = !stop_btn.visible
			});
			stop_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				isStart = false;
				start_btn.visible = !start_btn.visible;
				stop_btn.visible = !stop_btn.visible
			});
		}
		private function __createComplete(e:Event):void
		{
			drawBackGround();
			removeEventListener(ComponentEvent.DRAW_COMPLETE,__createComplete);
		}
		public function addLog(obj:*,tag:String = ""):void
		{
			if(!isStart) return;
				addLoged(obj,tag);
		}
		internal function addLogDirectly(obj:*,tag:String = ""):void
		{
			addLoged(obj,tag);
		}
		private function addLoged(obj:*,tag:String = ""):void
		{
			var text_button:TextPanel = DebugSystem.getDebugTextButton(obj,(tag==""?"":tag+" : ")+getQualifiedClassName(obj));
//			_logMap[text_button] = obj;
			addItem(text_button,obj);
			_logArr.push(text_button);
			tileContainer.appendItem(text_button);
			
			if(_logArr.length>=log_max_count)
			{
				var shift_btn:TextPanel;
				shift_btn = _logArr.shift();
//				delete _logMap[shift_btn];
				removeItem(shift_btn);
				tileContainer.removeItem(shift_btn);
			}
		}
		public function cleanLog():void
		{
			tileContainer.removeAllChildren();
			_logArr = [];
			_logMap = new Dictionary;
			_logWeakMap = new WeakMap;
		}
		private function addItem(key:Object,value:Object):void
		{
			if(_weak)
				_logWeakMap.add(key,value);
			else
				_logMap[key] = value;
		}
		private function getItem(key:*):*
		{
			if(_weak)
				return _logWeakMap.getValue(key);
			else
				_logMap[key];
		}
		public function checkGC():void
		{
			if(_weak == false) return;
			var text_arr:Array=_logWeakMap.keySet;
			for each(var i:TextPanel in text_arr)
			{
				if(!_logWeakMap.getValue(i))
				{
					i.color=0x00ff00;
				};
			}
		}
		private function removeItem(key:*):void
		{
			if(_weak)
				_logWeakMap.remove(key);
			else
				delete _logMap[key];
		}
		internal function get logMap():Dictionary
		{
			return _logMap;
		}
		internal function get weakMap():WeakMap
		{
			return _logWeakMap;
		}
	}
}
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
	
	public class DebugLogViewer extends DragPanel
	{
		private var _logArr:Array = [];
		private var _logMap:Dictionary = new Dictionary;
		private var log_max_count:uint = 200;
		
		private var scrollPanel:ScrollPanel = new ScrollPanel;
		private var tileContainer:TileContainer = new TileContainer;
		private var btn_Container:TileContainer = new TileContainer;
		private var clean_btn:TextPanel = new TextPanel(0xffff00);
		private var start_btn:TextPanel = new TextPanel(0xffff00);
		private var stop_btn:TextPanel = new TextPanel(0xffff00);
		private var start_stop_container:Sprite = new Sprite;
		
		private var isStart:Boolean = true;
		
		public function DebugLogViewer()
		{
			super();
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
			scrollPanel.addEventListener(ComponentEvent.UPDATE,__createComplete);
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
			removeEventListener(ComponentEvent.UPDATE,__createComplete);
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
			_logMap[text_button] = obj;
			_logArr.push(text_button);
			tileContainer.appendItem(text_button);
			
			if(_logArr.length>=log_max_count)
			{
				var shift_btn:TextPanel;
				shift_btn = _logArr.shift();
				delete _logMap[shift_btn];
				tileContainer.removeItem(shift_btn);
			}
		}
		public function cleanLog():void
		{
			tileContainer.removeAllChildren();
			_logArr = [];
			_logMap = new Dictionary;
		}
		internal function get logMap():Dictionary
		{
			return _logMap;
		}
	}
}
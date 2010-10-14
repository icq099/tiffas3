package yzhkof.debug
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.ui.DragPanel;
	import yzhkof.ui.ScrollPanel;
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.ui.event.ComponentEvent;
	
	public class DebugWatcherViewer extends DragPanel
	{
		private var watch_arr:Array = [];
		private var textField_arr:Array = [];
		private var scrollPanel:ScrollPanel = new ScrollPanel;
		private var tileContainer:TileContainer = new TileContainer;
		private var btn_Container:TileContainer = new TileContainer;
		private var clear_btn:TextPanel = new TextPanel(0xffff00);
		
		public function DebugWatcherViewer()
		{
			super();
			initView();
			init();
			addEvent();
		}
		private function init():void
		{
			
		}
		private function initView():void
		{
			content.addChild(scrollPanel);
			scrollPanel.source = tileContainer;
			scrollPanel.width = 500;
			scrollPanel.height = 400;
			tileContainer.width = scrollPanel .width - 10;
			tileContainer.columnCount = 1;
			
			clear_btn.text = "清除";
			btn_Container.appendItem(clear_btn);
			content.addChild(btn_Container);
			tileContainer.y = 20;
		}
		private function addEvent():void
		{
			scrollPanel.addEventListener(ComponentEvent.DRAW_COMPLETE,__createComplete);
			addEventListener(Event.ENTER_FRAME,__enterFrame);
			clear_btn.addEventListener(MouseEvent.CLICK,__clearClick);
		}

		private function __clearClick(event:MouseEvent):void
		{
			for each (var element:DisplayObject in textField_arr)
			{
				tileContainer.removeItem(element);
			}
			watch_arr = [];
			textField_arr = [];
		}
		private function __enterFrame(event:Event):void
		{
			for (var i:String in watch_arr)
			{
				var data:WatchData = WatchData(watch_arr[i]);
				var params:Array = data.property.split(".");
				var current_object:* = data.object;
				var current_value:*;
				for each (var element:String in params)
				{
					if(current_object == null)
					{
						current_value = null;
						break;
					}
					current_value = current_object[element];
					current_object = current_value;
				}
				textField_arr[i].text = (data.name||getQualifiedClassName(data.object)) + ":" + current_value; 
			}
			if(visible)
				tileContainer.draw();
		}
		private function __createComplete(e:Event):void
		{
			drawBackGround();
			removeEventListener(ComponentEvent.DRAW_COMPLETE,__createComplete);
		}
		public function addWatch(obj:Object,property:String,name:String = null):void
		{
			var data:WatchData = new WatchData;
			data.object = obj;
			data.property = property;
			data.name = name;
			watch_arr.push(data);
			var text:TextField = new TextField;
			text.autoSize = TextFieldAutoSize.LEFT;
			textField_arr.push(text);
			tileContainer.appendItem(text);
		}
	}
}

class WatchData extends Object
{
	public var object:Object;
	public var property:String;
	public var name:String;
}
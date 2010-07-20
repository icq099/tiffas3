package yzhkof.debug
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.AddToStageSetter;
	import yzhkof.KeyMy;
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.util.DebugUtil;
	import yzhkof.util.WeakMap;

	public class DebugDisplayObjectDctionary extends TileContainer
	{
		internal var _dobj_map:WeakMap;
		private var viewer:DebugDisplayObjectViewer;
		public function DebugDisplayObjectDctionary()
		{
			super();
			AddToStageSetter.delayExcuteAfterAddToStage(this,function():void{
				width = stage.stageWidth;
				stage.addEventListener(Event.RESIZE,function(e:Event):void{
					width = stage.stageWidth;
				});
			});
		}
		public function checkGC():void
		{
			var text_arr:Array=_dobj_map.keySet;
			for each(var i:TextPanel in text_arr)
			{
				if(!_dobj_map.getValue(i))
				{
					i.color=0x00ff00;
				};
			}
		}
		public function setup(viewer:DebugDisplayObjectViewer):void
		{
			this.viewer=viewer;	
		}
		public function goto(dobj:*):void
		{
			var text_arr:Array=new Array;
			reset();
			var t:TextPanel;
			if(dobj is DisplayObject)
			{
				do
				{
					t = DebugSystem.getDebugTextButton(dobj,(new RegExp("instance").test(dobj.name)?getQualifiedClassName(dobj):dobj.name)||getQualifiedClassName(dobj));
					text_arr.push(t);
					text_arr.push(arrow);
					_dobj_map.add(t,dobj);
				}while(dobj=dobj.parent);
				text_arr.pop();
				var length:uint=text_arr.length
				var i:int;
				for (i=0;i<length;i++)
				{
					var tdobj:TextPanel=TextPanel(text_arr.pop());
					appendItem(tdobj);
				}
			}
		}
		public function select(arr:Array):void
		{
			reset();
			var t:TextPanel;
			for each(var j:DisplayObject in arr)
			{
				t = DebugSystem.getDebugTextButton(j,(new RegExp("instance").test(j.name)?getQualifiedClassName(j):j.name)||getQualifiedClassName(j));
				_dobj_map.add(t,j);
				appendItem(t);
			}
		}
		private function reset():void
		{
			_dobj_map=new WeakMap;
			removeAllChildren();
		}
		private function get arrow():TextPanel
		{
			var re_t:TextPanel=new TextPanel();
			re_t.text=">>";
			return re_t;
		}

		public function get dobj_map():WeakMap
		{
			return _dobj_map;
		}
	}
}
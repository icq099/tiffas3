package yzhkof.debug
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.util.WeakMap;

	public class DebutDisplayObjectDctionary extends TileContainer
	{
		private var dobj_map:WeakMap;
		private var viewer:DebugDisplayObjectViewer;
		public function DebutDisplayObjectDctionary()
		{
			super();
			width = 1000;
			height = 100;
		}
		public function checkGC():void
		{
			var text_arr:Array=dobj_map.keySet;
			for each(var i:TextPanel in text_arr)
			{
				if(!dobj_map.getValue(i))
				{
					i.color=0x00ff00;
				};
			}
		}
		public function setup(viewer:DebugDisplayObjectViewer):void
		{
			this.viewer=viewer;	
		}
		public function goto(dobj:DisplayObject):void
		{
			var text_arr:Array=new Array;
			dobj_map=new WeakMap;
			removeAllChildren();
			do
			{
				var t:TextPanel;
				if(dobj.visible==false)
				{
					t = new TextPanel(0xff0000);
				}
				else if(dobj.width==0||dobj.height==0)
				{
					t = new TextPanel(0x0000ff);
				}
				else
				{
					t = new TextPanel();
				}
				
				t.text=getQualifiedClassName(dobj);
				text_arr.push(t);
				text_arr.push(arrow);
				dobj_map.add(t,dobj);
				
				t.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
				{
					if(viewer)
					{
						if(e.ctrlKey)
						{
							viewer.view(dobj_map.getValue(e.currentTarget));
						}
						else if(e.shiftKey)
						{
							debugObjectTrace(dobj_map.getValue(e.currentTarget));
						}
						else
						{
							viewer.goto(dobj_map.getValue(e.currentTarget));
						}
					}
				});
				
			}while(dobj=dobj.parent);
			text_arr.pop();
			var length:uint=text_arr.length
			var i:int;
			for (i=0;i<length;i++)
			{
				var tdobj:TextPanel=TextPanel(text_arr.pop());
				addChild(tdobj);
			}
			
		}
		private function get arrow():TextPanel
		{
			var re_t:TextPanel=new TextPanel();
			re_t.text=">>";
			return re_t;
		}
		
	}
}
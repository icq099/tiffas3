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

	public class DebutDisplayObjectDctionary extends TileContainer
	{
		private var dobj_map:WeakMap;
		private var viewer:DebugDisplayObjectViewer;
		public function DebutDisplayObjectDctionary()
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
		public function goto(dobj:*):void
		{
			var text_arr:Array=new Array;
			dobj_map=new WeakMap;
			removeAllChildren();
			var __textPanelClickHandle:Function = function(e:MouseEvent):void
			{
				if(viewer)
				{
					if(KeyMy.isDown(83))
					{
						//debugTrace(SampleUtil.getInstanceCreatPath(dobj_map.getValue(e.currentTarget)));
						debugTrace(DebugUtil.analyseInstance(dobj_map.getValue(e.currentTarget)));
					}
					else if(KeyMy.isDown(84))
					{
						DebugSystem.scriptViewer.setTarget(dobj_map.getValue(e.currentTarget));
					}
					else if(e.ctrlKey)
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
			}
			var t:TextPanel;
			if(dobj is DisplayObject)
			{
				do
				{					
					if(dobj.visible==false)
					{
						t = new TextPanel(0xff0000);
					}
					else if(dobj.getBounds(dobj).width==0||dobj.getBounds(dobj).height==0)
					{
						t = new TextPanel(0x0000ff);
					}
					else
					{
						t = new TextPanel();
					}
					t.text=(new RegExp("instance").test(dobj.name)?getQualifiedClassName(dobj):dobj.name)||getQualifiedClassName(dobj);
					text_arr.push(t);
					text_arr.push(arrow);
					dobj_map.add(t,dobj);
					
					t.addEventListener(MouseEvent.CLICK,__textPanelClickHandle);
					
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
			else if(dobj is Array)
			{
				for each(var j:DisplayObject in dobj)
				{
					t = new TextPanel;
					t.text = (new RegExp("instance").test(j.name)?getQualifiedClassName(j):j.name)||getQualifiedClassName(j);
					t.addEventListener(MouseEvent.CLICK,__textPanelClickHandle);
					dobj_map.add(t,j);
					appendItem(t);
				}
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
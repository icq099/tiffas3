package yzhkof.debug
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.KeyMy;
	import yzhkof.MyGC;
	import yzhkof.MyGraphy;
	import yzhkof.ui.BackGroudContainer;
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.util.DebugUtil;
	import yzhkof.util.WeakMap;

	public class DebugDisplayObjectViewer extends BackGroudContainer
	{
		private var container:TileContainer=new TileContainer();
		private var btn_container:TileContainer=new TileContainer();
		private var _currentLeaf:WeakMap;
		private var _latestLeaf:WeakMap;
		private var dictionary_viewer:DebutDisplayObjectDctionary;		
		
		private var _stage:Stage;
		private var child_map:WeakMap;
		private var up_btn:TextPanel;
		private var back_btn:TextPanel;
		private var stage_btn:TextPanel;
		private var text_btn:TextPanel;
		private var script_btn:TextPanel;
		private var refresh_btn:TextPanel;
		private var gc_btn:TextPanel;
		private var focus_txt:TextPanel;
		private var x_btn:TextPanel;
		private var mask_background:Sprite;
		private var viewer:SnapshotDisplayViewer;
		public function DebugDisplayObjectViewer(_stage:Stage)
		{
			super();
			this._stage=_stage;
			currentLeaf=_stage;
			init();
			initEvent();
		}
		private function set currentLeaf(value:DisplayObjectContainer):void
		{
			_currentLeaf=new WeakMap();
			_currentLeaf.add(0,value);
		}
		private function get currentLeaf():DisplayObjectContainer
		{
			return _currentLeaf.getValue(0) as DisplayObjectContainer;
		}
		private function set latestLeaf(value:DisplayObjectContainer):void
		{
			_latestLeaf=new WeakMap();
			_latestLeaf.add(0,value);
		}
		private function get latestLeaf():DisplayObjectContainer
		{
			return _latestLeaf.getValue(0) as DisplayObjectContainer;
		}
		private function init():void
		{
			viewer=new SnapshotDisplayViewer();
			dictionary_viewer=new DebutDisplayObjectDctionary();
			up_btn=new TextPanel();
			back_btn=new TextPanel();
			stage_btn=new TextPanel();
			text_btn=new TextPanel();
			script_btn=new TextPanel();
			refresh_btn=new TextPanel();
			gc_btn=new TextPanel();
			focus_txt=new TextPanel();
			x_btn=new TextPanel();
			
			dictionary_viewer.setup(this);
			dictionary_viewer.y = 25;
			mask_background=MyGraphy.drawRectangle(_stage.stageWidth,_stage.stageHeight);
			mask_background.alpha=0.5;
			btn_container.width=500;
			btn_container.height=200;
			
			refresh_btn.text="刷新";
			back_btn.text="后退";
			up_btn.text="向上";
			stage_btn.text="舞台";
			script_btn.text="脚本";
			text_btn.text="文本";
			x_btn.text="隐藏";
			gc_btn.text="GC";
			
			
			addChild(btn_container);
			addChild(dictionary_viewer);
			addChild(container);
			addChild(mask_background);
			addChild(viewer);
			
			btn_container.addChild(up_btn);
			btn_container.addChild(back_btn);
			btn_container.addChild(stage_btn);
			btn_container.addChild(text_btn);
			btn_container.addChild(script_btn);
			btn_container.addChild(refresh_btn);
			btn_container.addChild(gc_btn);
			btn_container.addChild(x_btn);
			btn_container.addChild(focus_txt);
			
			
			container.y=120;
			container.width=_stage.stageWidth
			viewer.visible=false;
			mask_background.visible=false;
			goto(_stage);
			
		}
		private function initEvent():void
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,__onStageClick,false,int.MAX_VALUE,true);
			
			up_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				if(currentLeaf.parent!=null)
				{
					goto(currentLeaf.parent);
				}else
				{
					goto(_stage);
				}
			});
			back_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				if(latestLeaf)
					goto(latestLeaf);
			});
			stage_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
					goto(_stage);
			});
			text_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
					TextTrace.visible=!TextTrace.visible;
			});
			script_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
					DebugSystem.scriptViewer.visible=!DebugSystem.scriptViewer.visible;
			});
			mask_background.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				viewer.clearView();
				mask_background.visible=false;
			});
			viewer.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				viewer.clearView();
				mask_background.visible=false;
			});
			refresh_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				refresh();
			});
			gc_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				System.gc();
				MyGC.gc();
				checkGC();
				dictionary_viewer.checkGC();
			});
			focus_txt.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			{
				if(_stage.focus)
				{
					if(e.shiftKey)
					{
						debugObjectTrace(_stage.focus)
					}else if(e.ctrlKey)
					{
						view(_stage.focus);
					}else
					{
						var t:DisplayObjectContainer;
						if(_stage.focus is DisplayObjectContainer)
						{
							t=_stage.focus as DisplayObjectContainer;
						}else
						{
							t=_stage.focus.parent;
						}
						goto(t);
					}
				}
			});
			x_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				visible=!visible;
			});
			addEventListener(Event.ENTER_FRAME,function(e:Event):void
			{
				focus_txt.text="stage.focus = \""+getQualifiedClassName(_stage.focus)+"\"";	
			});
		}
		private function __onStageClick(e:MouseEvent):void
		{
			if(e.altKey)
			{
				var dobj:DisplayObject=DisplayObject(e.target);
				var str:String="";
				var go_dobj:DisplayObjectContainer;
				do
				{
					var t:String=getQualifiedClassName(dobj);
					switch(t)
					{
						case "flash.display::Stage":
						case "flash.display::MovieClip":
						case "flash.text::TextField":
						case "flash.display::Sprite":
							continue;
						break;
					}
					str+=t+" || ";
					if((dobj is DisplayObjectContainer)&&(go_dobj==null))
					{
						go_dobj=DisplayObjectContainer(dobj);
					}
				}
				while(dobj=dobj.parent)
				if(go_dobj)
				{
					goto(go_dobj);
				}
				trace(str);
			}
		}
		public function goto(dobjc:DisplayObjectContainer):void
		{
			if(dobjc!=null)
			{
				latestLeaf=currentLeaf;
				currentLeaf=dobjc;
				dictionary_viewer.goto(dobjc);
				refresh();
			}else
			{
				goto(_stage);
			}	
		}
		public function view(dobj:DisplayObject):void
		{
			viewer.view(dobj);
			viewer.visible=true;
			mask_background.visible=true;
		}
		private function refresh():void
		{
			if(currentLeaf==null)
			{
				goto(_stage);
			}
			container.removeAllChildren();
			child_map=new WeakMap;
			var i:int;
			var length:uint=currentLeaf.numChildren;
			for(i=0;i<length;i++)
			{
				var t_text:TextPanel;
				var t_dobj:DisplayObject=currentLeaf.getChildAt(i);
				if(t_dobj.visible==false)
				{
					t_text= new TextPanel(0xff0000);
				}
				else if(t_dobj.width==0||t_dobj.height==0)
				{
					t_text=new TextPanel(0x0000ff);
				}
				else if(t_dobj is DisplayObjectContainer)
				{
					t_text= new TextPanel(0xffff00);
				}else
				{
					t_text= new TextPanel;
				}
				container.addChild(t_text);
				t_text.text=getQualifiedClassName(t_dobj);
				child_map.add(t_text,t_dobj);
				t_text.doubleClickEnabled=true;
				t_text.addEventListener(MouseEvent.CLICK,__onItemClick);
			}
			container.updataChildPosition();
		}
		public function checkGC():void
		{
			var text_arr:Array=child_map.keySet;
			for each(var i:TextPanel in text_arr)
			{
				if(!child_map.getValue(i))
				{
					i.color=0x00ff00;
				};
			}
		}
		private function __onItemClick(e:MouseEvent):void
		{
			var gotoObj:DisplayObject=child_map.getValue(e.currentTarget);
			if(KeyMy.isDown(83))
			{
//				debugTrace(SampleUtil.getInstanceCreatPath(child_map.getValue(e.currentTarget)));
				debugTrace(DebugUtil.analyseInstance(child_map.getValue(e.currentTarget)));
			}
			else if(KeyMy.isDown(84))
			{
				DebugSystem.scriptViewer.setTarget(child_map.getValue(e.currentTarget));
			}
			else if(e.ctrlKey)
			{
				view(child_map.getValue(e.currentTarget));
			}
			else if(e.shiftKey)
			{
				debugObjectTrace(child_map.getValue(e.currentTarget));
			}
			else if(gotoObj is DisplayObjectContainer)
			{
				goto(DisplayObjectContainer(gotoObj));
			}
		}
		
	}
}
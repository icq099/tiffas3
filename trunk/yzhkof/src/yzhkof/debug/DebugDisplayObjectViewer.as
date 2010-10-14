package yzhkof.debug
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.getMemberNames;
	import flash.system.System;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import yzhkof.KeyMy;
	import yzhkof.MyGC;
	import yzhkof.MyGraphy;
	import yzhkof.ui.ComponentBase;
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.util.DebugUtil;
	import yzhkof.util.RightMenuUtil;
	import yzhkof.util.WeakMap;

	public class DebugDisplayObjectViewer extends ComponentBase
	{
		public static var SIMPLE:String = "simple";
		public static var DETAIL:String = "detail";
		
		private var container:TileContainer=new TileContainer();
		private var btn_container:TileContainer=new TileContainer();
		private var _currentLeaf:WeakMap;
		private var _latestLeaf:WeakMap;
		private var dictionary_viewer:DebugDisplayObjectDctionary;
		private var currentRefreshType:String = "simple";
		private var _drager:DebugDrag;
		
		private var _stage:Stage;
		private var _child_map:WeakMap;
		private var fold_btn:TextPanel;
//		private var extend_btn:TextPanel;
		private var back_btn:TextPanel;
		private var stage_btn:TextPanel;
		private var mode_btn_a:TextPanel;
		private var mode_btn_b:TextPanel;
		private var text_btn:TextPanel;
		private var script_btn:TextPanel;
		private var refresh_btn:TextPanel;
		private var gc_btn:TextPanel;
		private var log_btn:TextPanel;
		private var focus_txt:TextPanel;
		private var x_btn:TextPanel;
		private var mode_container:Sprite;
		private var mask_background:Sprite;
		private var viewer:SnapshotDisplayViewer;
		private var locateContainer:Sprite;
		private var watcher_btn:TextPanel;
		
		public function DebugDisplayObjectViewer(_stage:Stage)
		{
			super();
			this._stage=_stage;
			currentLeaf=_stage;
			init();
			initEvent();
		}
		private function set currentLeaf(value:*):void
		{
			_currentLeaf=new WeakMap();
			_currentLeaf.add(0,value);
		}
		private function get currentLeaf():*
		{
			return _currentLeaf.getValue(0);
		}
		private function set latestLeaf(value:*):void
		{
			_latestLeaf=new WeakMap();
			_latestLeaf.add(0,value);
		}
		private function get latestLeaf():*
		{
			return _latestLeaf.getValue(0);
		}
		private function init():void
		{
			_drager = new DebugDrag;
			viewer=new SnapshotDisplayViewer();
			locateContainer = new Sprite;
			dictionary_viewer=new DebugDisplayObjectDctionary();
			mode_container = new Sprite;
			fold_btn=new TextPanel();
			back_btn=new TextPanel();
			stage_btn=new TextPanel();
			text_btn=new TextPanel();
			script_btn=new TextPanel();
			refresh_btn=new TextPanel();
			gc_btn=new TextPanel();
			log_btn=new TextPanel();
			watcher_btn=new TextPanel();
			focus_txt=new TextPanel();
			x_btn=new TextPanel();
			mode_btn_a = new TextPanel();
			mode_btn_b = new TextPanel();
			
			dictionary_viewer.setup(this);
			dictionary_viewer.y = 25;
			
			btn_container.width=1000;
			btn_container.height=200;
			container.width=_stage.stageWidth;
			locateContainer.mouseChildren = locateContainer.mouseEnabled = false;
			
			refresh_btn.text="刷新";
			back_btn.text="后退";
			fold_btn.text="收起";
			stage_btn.text="舞台";
			script_btn.text="脚本";
			text_btn.text="文本";
			mode_btn_a.text="简易";
			mode_btn_b.text="详细";
			
			x_btn.text="隐藏";
			gc_btn.text="GC";
			log_btn.text="log";
			watcher_btn.text="查看";
			
			addChild(btn_container);
			addChild(dictionary_viewer);
			addChild(container);
			mode_container.addChild(mode_btn_a);
			mode_container.addChild(mode_btn_b);
			mode_btn_b.visible = false;
			setMaskBackGround(MyGraphy.drawRectangle(_stage.stageWidth,_stage.stageHeight));
			addChild(viewer);
			addChild(locateContainer);
			
			btn_container.appendItem(fold_btn);
			btn_container.appendItem(back_btn);
			btn_container.appendItem(stage_btn);
			btn_container.appendItem(text_btn);
			btn_container.appendItem(script_btn);
			btn_container.appendItem(refresh_btn);
			btn_container.appendItem(gc_btn);
			btn_container.appendItem(log_btn);
			btn_container.appendItem(watcher_btn);
			btn_container.appendItem(mode_container);
			btn_container.appendItem(x_btn);
			btn_container.appendItem(focus_txt);
			
			container.width=_stage.stageWidth
			viewer.visible=false;
			mask_background.visible=false;
		}
		private function setMaskBackGround(dobj:Sprite):void
		{
			if(mask_background)
				removeChild(mask_background);
			mask_background = dobj;
			mask_background.alpha=0.5;
			mask_background.visible = false;
			addChildAt(mask_background,viewer.parent == this?getChildIndex(viewer):numChildren);
			mask_background.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				viewer.clearView();
				mask_background.visible=false;
			});
		}
		private function initEvent():void
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,__onStageClick,true,int.MAX_VALUE,true);
			_stage.addEventListener(Event.RESIZE,function(e:Event):void{
				commitChage();
			});
			fold_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				visible = false;
			});
			mode_btn_a.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				mode_btn_b.visible = true;
				mode_btn_a.visible = false;
				currentRefreshType = DETAIL;
				refresh(currentRefreshType);
			});
			mode_btn_b.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				mode_btn_b.visible = false;
				mode_btn_a.visible = true;
				currentRefreshType = SIMPLE;
				refresh(currentRefreshType);
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
			log_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				DebugSystem.logViewer.visible = !DebugSystem.logViewer.visible;
			});
			watcher_btn.addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				DebugSystem.watchViewer.visible = !DebugSystem.watchViewer.visible;
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
				DebugSystem._mainContainer.visible=!DebugSystem._mainContainer.visible;
			});
			addEventListener(Event.ENTER_FRAME,function(e:Event):void
			{
				focus_txt.text="stage.focus = \""+getQualifiedClassName(_stage.focus)+"\"";	
			});
		}
		override protected function onDraw():void
		{ 
			setMaskBackGround(MyGraphy.drawRectangle(_stage.stageWidth,_stage.stageHeight));
			container.width=_stage.stageWidth;
			container.y=dictionary_viewer.y+dictionary_viewer.contentHeight+25;
		}
		private function __onStageClick(e:MouseEvent):void
		{
			if(e.altKey)
			{
				var dobj:DisplayObject=DisplayObject(e.target);
				var dobj_arr:Array =_stage.getObjectsUnderPoint(new Point(e.stageX,e.stageY));
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
				
				var parent_arr:Array = [];
				if(dobj_arr)
				{
					for each(var i:DisplayObject in dobj_arr)
					{
						if(i is DisplayObjectContainer) continue;
						parent_arr.push(i.parent);
					}
					goto(parent_arr.concat(dobj_arr),true);
				}
				trace(str);
			}
		}
		public function goto(obj:*,select:Boolean = false):void
		{
			if(obj!=null)
			{
				latestLeaf=currentLeaf;
				currentLeaf=obj;
				if(select)
				{
					dictionary_viewer.select(obj);
				}
				else
				{
					dictionary_viewer.goto(obj);
				}
				refresh(currentRefreshType);
				commitChage();
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
		private function getTextPanel(obj:*):TextPanel
		{
			var t_text:TextPanel;
			if(obj is DisplayObject)
			{
				if(obj.visible==false)
				{
					t_text = new TextPanel(0xff0000);
				}
				else if(obj.getBounds(obj).width==0||obj.getBounds(obj).height==0)
				{
					t_text = new TextPanel(0x0000ff);
				}
				else if(obj is DisplayObjectContainer)
				{
					t_text = new TextPanel(0xffff00);
				}else
				{
					t_text = new TextPanel;
					
				}
			}
			else if(obj is Function)
			{
				t_text = new TextPanel(0x8888ff);
			}
			else
			{
				if(obj == null)
				{
					t_text = new TextPanel(0x888888);
				}else
				{
					t_text = new TextPanel(0xff8888);
				}
			}
			return t_text;
		}
		private function refresh(type:String = ""):void
		{
			var t_currentLeaf:* = currentLeaf;
			var t_type:String = type == ""?currentRefreshType:type;
			if(t_currentLeaf==null)
			{
				goto(_stage);
			}
			container.removeAllChildren();
			_child_map=new WeakMap;
			reference_arr = new Array;
			var t_text:TextPanel;
			if(t_currentLeaf is DisplayObjectContainer)
			{
				var i:int;
				var length:uint=t_currentLeaf.numChildren;
				for(i=0;i<length;i++)
				{
					var t_dobj:DisplayObject=t_currentLeaf.getChildAt(i);
					t_text = getDebugTextButton(t_dobj,new RegExp("instance").test(t_dobj.name)?getQualifiedClassName(t_dobj):t_dobj.name);
					container.appendItem(t_text);
					child_map.add(t_text,t_dobj);
				}
			}
			if(t_type == DETAIL)
			{
				var menber:Object = getMemberNames(t_currentLeaf);
				var text_buttons:Array = new Array;
				for each(var q:QName in menber)
				{
									
					try{
						var t_v:* = t_currentLeaf[q];
							
						t_text = getDebugTextButton(t_v,q.localName);
						text_buttons.push(t_text);
						
						reference_arr.push(t_v);
						_child_map.add(t_text,t_v);
							
					}catch(e:Error)
					{
						
					}				
				}
				text_buttons.sortOn("text");
				for each (var element:TextPanel in text_buttons)
				{
					container.appendItem(element);
				}
			}
			container.draw();
		}
		private var reference_arr:Array = [];
		public function checkGC():void
		{
			var text_arr:Array=_child_map.keySet;
			for each(var i:TextPanel in text_arr)
			{
				if(!_child_map.getValue(i))
				{
					i.color=0x00ff00;
				};
			}
		}
		public function getDebugTextButton(obj:*,text:String):TextPanel
		{
			var text_panel:TextPanel = getTextPanel(obj);
			text_panel.text = text||"";
			text_panel.addEventListener(MouseEvent.CLICK,__onItemClick);
			if(obj is DisplayObject)
			{
				text_panel.addEventListener(MouseEvent.ROLL_OVER,__onItemOver);
				text_panel.addEventListener(MouseEvent.ROLL_OUT,__onItemOut);
			}
			addTextButtonRightMenu(text_panel,obj);
			return text_panel;
		}

		private function addTextButtonRightMenu(text_panel:TextPanel,obj:*):void
		{
			RightMenuUtil.hideDefaultMenus(text_panel);
			var item:ContextMenuItem;
			item = RightMenuUtil.addRightMenu(text_panel,"定位至脚本");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
			if(obj is DisplayObject)
			{
				item = RightMenuUtil.addRightMenu(text_panel,"快照");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
				item = RightMenuUtil.addRightMenu(text_panel,"移动");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
			}
			item = RightMenuUtil.addRightMenu(text_panel,"察看属性值");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
			if(obj is EventDispatcher)
			{
				item = RightMenuUtil.addRightMenu(text_panel,"察看监听器");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
			}
			item = RightMenuUtil.addRightMenu(text_panel,"log");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
			item = RightMenuUtil.addRightMenu(text_panel,"复制名字");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
			item = RightMenuUtil.addRightMenu(text_panel,"继承结构");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__rightMenuClick);
		}

		private function __rightMenuClick(event:ContextMenuEvent):void
		{
			doTextButtonAction(TextPanel(event.contextMenuOwner),ContextMenuItem(event.currentTarget).caption);
		}
		private function __onItemOver(e:MouseEvent):void
		{
			var gotoObj:DisplayObject=_child_map.getValue(e.currentTarget);
			if(gotoObj == null)
			{
				gotoObj = dictionary_viewer._dobj_map.getValue(e.currentTarget);
			}
			if(gotoObj == null)
			{
				gotoObj = DebugSystem.logViewer.logMap[e.currentTarget]; 
			}
			if(gotoObj&&gotoObj.stage)
			{
				var rect:Rectangle = gotoObj.getRect(stage);
				locateContainer.graphics.lineStyle(2,0xff0000);
				locateContainer.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
				var point:Point = DisplayObject(gotoObj).localToGlobal(new Point);
				locateContainer.graphics.drawCircle(point.x,point.y,10);
				locateContainer.graphics.drawCircle(point.x,point.y,1);
			}
		}
		private function __onItemOut(event:MouseEvent):void
		{
			locateContainer.graphics.clear();
		}
		private function __onItemClick(e:MouseEvent):void
		{
			doTextButtonAction(TextPanel(e.currentTarget));
		}
		private function doTextButtonAction(target:TextPanel,rightMenuName:String = ""):void
		{
			var gotoObj:*=_child_map.getValue(target);
			if(gotoObj == null)
			{
				gotoObj = dictionary_viewer._dobj_map.getValue(target);
			}
			if(gotoObj == null)
			{
				gotoObj = DebugSystem.logViewer.logMap[target]; 
			}
			if((KeyMy.isDown(83))||(rightMenuName == "察看监听器"))
			{
				debugTrace(DebugUtil.analyseInstance(gotoObj));
			}
			else if((KeyMy.isDown(84))||(rightMenuName == "定位至脚本"))
			{
				DebugSystem.scriptViewer.setTarget(gotoObj);
			}
			else if((KeyMy.isDown(87))||(rightMenuName == "log"))
			{
				DebugSystem.logViewer.addLogDirectly(gotoObj,"<watch>");
			}
			else if((KeyMy.isDown(17))||(rightMenuName == "快照"))
			{
				if(gotoObj is DisplayObject)
					view(gotoObj);
			}
			else if((KeyMy.isDown(16))||(rightMenuName == "察看属性值"))
			{
				debugObjectTrace(gotoObj);
			}
			else if(rightMenuName == "移动")
			{
				if(gotoObj!=null && gotoObj is DisplayObject)
					_drager.target = gotoObj;
			}
			else if(rightMenuName == "复制名字")
			{
				var name_arr:Array = target.text.split("::");
				System.setClipboard(name_arr.length>1?name_arr[1]:name_arr[0]);
			}
			else if(rightMenuName == "继承结构")
			{
				if(gotoObj == null) return;
				var str:String = "";
				var current:* = gotoObj;
				while(1)
				{
					try
					{
						current = getDefinitionByName(getQualifiedSuperclassName(current));
						str = "->" + current + "\n" + str;
					}catch(e:Error)
					{
						break;
					};
				}
				debugObjectTrace(str);
			}
			else
			{
				if(gotoObj == null)
				{
					debugObjectTrace(gotoObj);
				}
				else if(gotoObj is Function)
				{
					DebugSystem.scriptViewer.setTarget(gotoObj);
				}
				else
				{
					switch(getDefinitionByName(getQualifiedClassName(gotoObj)))
					{
						case int:
						case Number:
						case String:
							debugObjectTrace(gotoObj);
						break;
						default:
							goto(gotoObj);
						break;
					}
				}
				
			}
		}

		public function get child_map():WeakMap
		{
			return _child_map;
		}
	}
}
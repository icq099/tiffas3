package yzhkof.debug
{
	import com.hurlant.eval.ast.In;
	import com.hurlant.eval.ast.StrictEqual;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.sampler.getMemberNames;
	import flash.system.System;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.KeyMy;
	import yzhkof.MyGC;
	import yzhkof.MyGraphy;
	import yzhkof.ui.BackGroudContainer;
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.util.DebugUtil;
	import yzhkof.util.WeakMap;
	import yzhkof.util.delayCallNextFrame;

	public class DebugDisplayObjectViewer extends BackGroudContainer
	{
		public static var SIMPLE:String = "simple";
		public static var DETAIL:String = "detail";
		
		private var container:TileContainer=new TileContainer();
		private var btn_container:TileContainer=new TileContainer();
		private var _currentLeaf:WeakMap;
		private var _latestLeaf:WeakMap;
		private var dictionary_viewer:DebutDisplayObjectDctionary;
		private var currentRefreshType:String = "simple";
		
		private var _stage:Stage;
		private var child_map:WeakMap;
		private var up_btn:TextPanel;
		private var back_btn:TextPanel;
		private var stage_btn:TextPanel;
		private var mode_btn_a:TextPanel;
		private var mode_btn_b:TextPanel;
		private var text_btn:TextPanel;
		private var script_btn:TextPanel;
		private var refresh_btn:TextPanel;
		private var gc_btn:TextPanel;
		private var focus_txt:TextPanel;
		private var x_btn:TextPanel;
		private var mode_container:Sprite;
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
			viewer=new SnapshotDisplayViewer();
			dictionary_viewer=new DebutDisplayObjectDctionary();
			mode_container = new Sprite;
			up_btn=new TextPanel();
			back_btn=new TextPanel();
			stage_btn=new TextPanel();
			text_btn=new TextPanel();
			script_btn=new TextPanel();
			refresh_btn=new TextPanel();
			gc_btn=new TextPanel();
			focus_txt=new TextPanel();
			x_btn=new TextPanel();
			mode_btn_a = new TextPanel();
			mode_btn_b = new TextPanel();
			
			dictionary_viewer.setup(this);
			dictionary_viewer.y = 25;
			
			btn_container.width=500;
			btn_container.height=200;
			container.width=_stage.stageWidth;
			
			refresh_btn.text="刷新";
			back_btn.text="后退";
			up_btn.text="向上";
			stage_btn.text="舞台";
			script_btn.text="脚本";
			text_btn.text="文本";
			mode_btn_a.text="简易";
			mode_btn_b.text="详细";
			
			x_btn.text="隐藏";
			gc_btn.text="GC";
			
			
			addChild(btn_container);
			addChild(dictionary_viewer);
			addChild(container);
			mode_container.addChild(mode_btn_a);
			mode_container.addChild(mode_btn_b);
			mode_btn_b.visible = false;
			setMaskBackGround(MyGraphy.drawRectangle(_stage.stageWidth,_stage.stageHeight));
			addChild(viewer);
			
			btn_container.appendItem(up_btn);
			btn_container.appendItem(back_btn);
			btn_container.appendItem(stage_btn);
			btn_container.appendItem(text_btn);
			btn_container.appendItem(script_btn);
			btn_container.appendItem(refresh_btn);
			btn_container.appendItem(gc_btn);
			btn_container.appendItem(mode_container);
			btn_container.appendItem(x_btn);
			btn_container.appendItem(focus_txt);
			
			container.width=_stage.stageWidth
			viewer.visible=false;
			mask_background.visible=false;
			goto(_stage);
			
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
				setMaskBackGround(MyGraphy.drawRectangle(_stage.stageWidth,_stage.stageHeight));
				container.width=_stage.stageWidth;
			});
			
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
		private function __onStageClick(e:MouseEvent):void
		{
			if(e.altKey)
			{
				var dobj:DisplayObject=DisplayObject(e.target);
//				var getObjectUnderPoint:Function = function():DisplayObject
//				{
//					var t_arr:Array = _stage.getObjectsUnderPoint(new Point(e.stageX,e.stageY));
//					var t_obj_arr:Array = [];
//					for each(var dobj:DisplayObject in t_arr)
//					{
//						if(!(dobj is DisplayObjectContainer))
//						{
//							t_obj_arr.push(dobj);
//						}
//					}
//					if(t_obj_arr.length>0)
//					{
//						return t_obj_arr.pop();
//					}else
//					{
//						return t_arr.pop();
//					}
//				}
//				var dobj:DisplayObject=getObjectUnderPoint();
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
					goto(parent_arr.concat(dobj_arr));
				}
				trace(str);
			}
		}
		private function updataContainerPosition():void
		{
			delayCallNextFrame(function():void{
				container.y=dictionary_viewer.y+dictionary_viewer.contentHeight+10;
			});
		}
		public function goto(obj:*):void
		{
			if(obj!=null)
			{
				latestLeaf=currentLeaf;
				currentLeaf=obj;
				dictionary_viewer.goto(obj);
				refresh(currentRefreshType);
				updataContainerPosition();
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
			}else
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
			child_map=new WeakMap;
			var t_text:TextPanel;
			if(t_currentLeaf is DisplayObjectContainer)
			{
				var i:int;
				var length:uint=t_currentLeaf.numChildren;
				for(i=0;i<length;i++)
				{
					var t_dobj:DisplayObject=t_currentLeaf.getChildAt(i);
					t_text = getTextPanel(t_dobj);
					container.appendItem(t_text);
					t_text.text= new RegExp("instance").test(t_dobj.name)?getQualifiedClassName(t_dobj):t_dobj.name
					child_map.add(t_text,t_dobj);
					t_text.addEventListener(MouseEvent.CLICK,__onItemClick);
				}
			}
			
			if(t_type == DETAIL)
			{
				var menber:Object = getMemberNames(t_currentLeaf);
				for each(var q:QName in menber)
				{
									
					try{
						var t_v:* = t_currentLeaf[q];
						if(!(t_v is Function))
						{
							t_text = getTextPanel(t_v);
							t_text.text = q.localName;
							if(String(q.uri)!="")
							{
								child_map.add(t_text,t_v);
							}
							else
							{
								child_map.add(t_text,t_currentLeaf[String(q.localName)]);
							}
							container.appendItem(t_text);
							t_text.addEventListener(MouseEvent.CLICK,__onItemClick);
						}					
					}catch(e:Error)
					{
						
					}				
				}
			}
			/*container.updataChildPosition();*/
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
			var gotoObj:*=child_map.getValue(e.currentTarget);
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
				if(gotoObj is DisplayObject)
					view(child_map.getValue(e.currentTarget));
			}
			else if(e.shiftKey)
			{
				debugObjectTrace(child_map.getValue(e.currentTarget));
			}
			else
			{
				if(gotoObj == null)
				{
					debugObjectTrace(gotoObj);
				}else
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
		
	}
}
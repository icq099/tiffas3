package plugins.lxfa.gehaiqingyun.view
{
	import caurina.transitions.Tweener;
	
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import fl.events.ListEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import memory.MemoryRecovery;
	import memory.MyGC;
	
	import mx.core.UIComponent;
	
	public class GeHaiQingYun extends UIComponent
	{
		private var geHaiQingYunSwc:GeHaiQingYunSwc;
		private var playListCtr:PlayListCtr;
		private var list:ListBg;
		public function GeHaiQingYun()
		{
			ScriptManager.getInstance().runScriptByName(ScriptName.STOP_RENDER,[]);
			initGeHaiQingYunSwc();
		}
		private function initGeHaiQingYunSwc():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		private function onAdded(e:Event):void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ADDED_TO_STAGE,onAdded);
			geHaiQingYunSwc=new GeHaiQingYunSwc();
			this.addChild(geHaiQingYunSwc);
			initList(geHaiQingYunSwc);
			initPlayListCtr();
			initListener();
		}
		private function initList(geHaiQingYunSwc:GeHaiQingYunSwc):void
		{
			list=new ListBg();
			geHaiQingYunSwc.addChild(list);
			geHaiQingYunSwc.playList.x=90000;
			list.visible=false;
			list.x=605;list.y=325;
		}
		private var btn_stop:BTNStopSwc=new BTNStopSwc();
		private function initListener():void
		{
			geHaiQingYunSwc.btn_playList.addEventListener(MouseEvent.CLICK,onClick);
			geHaiQingYunSwc.btn_play.addEventListener(MouseEvent.CLICK,onbtn_playClick);
			geHaiQingYunSwc.btn_play.visible=false;
			list.addEventListener(MouseEvent.DOUBLE_CLICK,onITEM_DOUBLE_CLICK);
			geHaiQingYunSwc.btn_pre.addEventListener(MouseEvent.CLICK,onbtn_preCLICK);
			geHaiQingYunSwc.btn_next.addEventListener(MouseEvent.CLICK,onbtn_nextCLICK);
			geHaiQingYunSwc.addChild(btn_stop);
			btn_stop.x=geHaiQingYunSwc.btn_play.x+23;
			btn_stop.y=geHaiQingYunSwc.btn_play.y+17;
			btn_stop.addEventListener(MouseEvent.CLICK,onbtn_stopClick);
			geHaiQingYunSwc.btn_Close.addEventListener(MouseEvent.CLICK,onbtn_CloseClick);
		}
		private function onbtn_CloseClick(e:Event):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				geHaiQingYunSwc.dispatchEvent(new Event(Event.CLOSE));
				PluginManager.getInstance().removePluginById("GeHaiQingYunModule");
			}
		}
		private var isTweening:Boolean=false;
		private function onClick(e:MouseEvent):void
		{
			if(!isTweening)
			{
				isTweening=true;
				if(list.visible==true)
				{
					list.mouseEnabled=false;
					Tweener.addTween(list,{scaleX:0,scaleY:0,time:1,onComplete:function():void{
						list.mouseEnabled=true;
					list.visible=false;
					isTweening=false;
					}});
				}
				else
				{
					list.scaleX=list.scaleY=0;
					list.visible=true;
					list.mouseEnabled=false;
					Tweener.addTween(list,{scaleX:1,scaleY:1,time:1,onComplete:function():void{
						list.mouseEnabled=true;
					isTweening=false;
					}});
				}
			}
		}
		private function onbtn_playClick(e:Event):void
		{
			if(list.visible==true)
			{
				if(playListCtr!=null)
				{
					playListCtr.playMedia(geHaiQingYunSwc.playList.selectedIndex);
				}
			}else
			{
				if(playListCtr!=null)
				{
					playListCtr.play();
				}
			}
			e.currentTarget.visible=false;
			btn_stop.visible=true;
		}
		private function onbtn_stopClick(e:MouseEvent):void
		{
			if(geHaiQingYunSwc!=null && geHaiQingYunSwc.btn_play!=null)
			{
				geHaiQingYunSwc.btn_play.visible=true;
				e.currentTarget.visible=false;
			}
			playListCtr.pause();
		}
		private function onITEM_DOUBLE_CLICK(e:ListEvent):void
		{
			if(playListCtr!=null)
			{
				playListCtr.playMedia(geHaiQingYunSwc.playList.selectedIndex);
			}
		}
		private function onbtn_preCLICK(e:MouseEvent):void
		{
			if(playListCtr!=null)
			{
				playListCtr.playPre();
			}
		}
		private function onbtn_nextCLICK(e:MouseEvent):void
		{
			if(playListCtr!=null)
			{
				playListCtr.playNext();
			}
		}
		private function initPlayListCtr():void
		{
			playListCtr=new PlayListCtr(geHaiQingYunSwc,list);
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(geHaiQingYunSwc.btn_playList,MouseEvent.CLICK,onClick);
			MemoryRecovery.getInstance().gcFun(geHaiQingYunSwc.btn_play,MouseEvent.CLICK,onbtn_playClick);
			MemoryRecovery.getInstance().gcFun(geHaiQingYunSwc.btn_pre,MouseEvent.CLICK,onbtn_preCLICK);
			MemoryRecovery.getInstance().gcFun(geHaiQingYunSwc.btn_next,MouseEvent.CLICK,onbtn_nextCLICK);
			MemoryRecovery.getInstance().gcFun(geHaiQingYunSwc.btn_Close,MouseEvent.CLICK,onbtn_CloseClick);
			if(geHaiQingYunSwc.btn_playList!=null)
			{
				if(geHaiQingYunSwc.btn_playList.parent!=null)
				{
					geHaiQingYunSwc.btn_playList.parent.removeChild(geHaiQingYunSwc.btn_playList);
				}
				geHaiQingYunSwc.btn_playList=null;
			}
			if(geHaiQingYunSwc.btn_play!=null)
			{
				if(geHaiQingYunSwc.btn_play.parent!=null)
				{
					geHaiQingYunSwc.btn_play.parent.removeChild(geHaiQingYunSwc.btn_play);
				}
				geHaiQingYunSwc.btn_play=null;
			}
			if(geHaiQingYunSwc.btn_pre!=null)
			{
				if(geHaiQingYunSwc.btn_pre.parent!=null)
				{
					geHaiQingYunSwc.btn_pre.parent.removeChild(geHaiQingYunSwc.btn_pre);
				}
				geHaiQingYunSwc.btn_pre=null;
			}
			if(geHaiQingYunSwc.btn_next!=null)
			{
				if(geHaiQingYunSwc.btn_next.parent!=null)
				{
					geHaiQingYunSwc.btn_next.parent.removeChild(geHaiQingYunSwc.btn_next);
				}
				geHaiQingYunSwc.btn_next=null;
			}
			if(geHaiQingYunSwc.btn_Close!=null)
			{
				if(geHaiQingYunSwc.btn_Close.parent!=null)
				{
					geHaiQingYunSwc.btn_Close.parent.removeChild(geHaiQingYunSwc.btn_Close);
				}
				geHaiQingYunSwc.btn_Close=null;
			}
			if(geHaiQingYunSwc!=null)
			{
				if(geHaiQingYunSwc.parent!=null)
				{
					geHaiQingYunSwc.parent.removeChild(geHaiQingYunSwc);
				}
				geHaiQingYunSwc=null;
			}
			if(playListCtr!=null)
			{
				playListCtr.dispose();
				playListCtr=null;
			}
			ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
			MyGC.gc();
		}
	}
}
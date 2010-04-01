package lxfa.gehaiqingyun.view
{
	import caurina.transitions.Tweener;
	
	import communication.MainSystem;
	
	import fl.events.ListEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.utils.MemoryRecovery;
	
	public class GeHaiQingYun extends Sprite
	{
		private var geHaiQingYunSwc:GeHaiQingYunSwc;
		private var playListCtr:PlayListCtr;
		private var list:ListBg;
		public function GeHaiQingYun()
		{
			MainSystem.getInstance().addAPI("getGeHaiQingYun",initGeHaiQingYunSwc);
		}
		private function initGeHaiQingYunSwc():GeHaiQingYunSwc
		{
			geHaiQingYunSwc=new GeHaiQingYunSwc();
			initList(geHaiQingYunSwc);
			initPlayListCtr();
			initListener();
			return geHaiQingYunSwc;
		}
		private function initList(geHaiQingYunSwc:GeHaiQingYunSwc):void
		{
			list=new ListBg();
			geHaiQingYunSwc.addChild(list);
			geHaiQingYunSwc.playList.visible=false;
			list.visible=false;
			list.x=605;list.y=325;
		}
		private function initListener():void
		{
			geHaiQingYunSwc.btn_playList.addEventListener(MouseEvent.CLICK,onClick);
			geHaiQingYunSwc.btn_play.addEventListener(MouseEvent.CLICK,onbtn_playClick);
			list.addEventListener(MouseEvent.DOUBLE_CLICK,onITEM_DOUBLE_CLICK);
			geHaiQingYunSwc.btn_pre.addEventListener(MouseEvent.CLICK,onbtn_preCLICK);
			geHaiQingYunSwc.btn_next.addEventListener(MouseEvent.CLICK,onbtn_nextCLICK);
			geHaiQingYunSwc.btn_Close.addEventListener(MouseEvent.CLICK,onbtn_CloseClick);
		}
		private function onbtn_CloseClick(e:Event):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				geHaiQingYunSwc.dispatchEvent(new Event(Event.CLOSE));
				MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["GeHaiQingYunModule"]);
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
			MemoryRecovery.getInstance().gcObj(geHaiQingYunSwc.btn_playList);
			MemoryRecovery.getInstance().gcObj(geHaiQingYunSwc.btn_play);
			MemoryRecovery.getInstance().gcObj(geHaiQingYunSwc.btn_pre);
			MemoryRecovery.getInstance().gcObj(geHaiQingYunSwc.btn_next);
			MemoryRecovery.getInstance().gcObj(geHaiQingYunSwc.btn_Close);
			MemoryRecovery.getInstance().gcObj(geHaiQingYunSwc);
			playListCtr.dispose();
			geHaiQingYunSwc=null;
			playListCtr=null;
		}
	}
}
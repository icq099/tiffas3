package lxfa.gehaiqingyun.view
{
	import fl.events.ListEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GeHaiQingYun extends Sprite
	{
		private var geHaiQingYunSwc:GeHaiQingYunSwc;
		private var playListCtr:PlayListCtr;
		public function GeHaiQingYun()
		{
			initGeHaiQingYunSwc();
			initPlayListCtr();
		}
		private function initGeHaiQingYunSwc():void
		{
			geHaiQingYunSwc=new GeHaiQingYunSwc();
			geHaiQingYunSwc.playList.visible=false;
			this.addChild(geHaiQingYunSwc);
			initListener();
		}
		private function initListener():void
		{
			geHaiQingYunSwc.btn_playList.addEventListener(MouseEvent.CLICK,onClick);
			geHaiQingYunSwc.btn_play.addEventListener(MouseEvent.CLICK,onbtn_playClick);
			geHaiQingYunSwc.playList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,onITEM_DOUBLE_CLICK);
			geHaiQingYunSwc.btn_pre.addEventListener(MouseEvent.CLICK,onbtn_preCLICK);
			geHaiQingYunSwc.btn_next.addEventListener(MouseEvent.CLICK,onbtn_nextCLICK);
		}
		private function onClick(e:Event):void
		{
			if(geHaiQingYunSwc.playList.visible==true)
			{
				geHaiQingYunSwc.playList.visible=false;
			}
			else
			{
				geHaiQingYunSwc.playList.visible=true;
			}
		}
		private function onbtn_playClick(e:Event):void
		{
			if(geHaiQingYunSwc.playList.visible==true)
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
			playListCtr=new PlayListCtr(geHaiQingYunSwc);
		}
		public function dispose():void
		{
			
		}
	}
}
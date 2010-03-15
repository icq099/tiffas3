package lsd.FanZhuSanJiao
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lxfa.view.player.FLVPlayer;
	
	public class FanZhuSangJiaoTest extends Sprite
	{
		private var fanZhuSangJiao:FanZhuSangJiaoSwc;
		private var flvPlayer:FLVPlayer;
		public function FanZhuSangJiaoTest()
		{
			initPlayer();
		}
		private function initPlayer():void
		{
			flvPlayer=new FLVPlayer("movie/gx-fz1.flv",900,480,false);
			this.addChild(flvPlayer);
			
			refreshBottomLocation();
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_play_complete);
		}
		private function on_play_complete(e:NetStatusEvent):void
		{
			init();
			if(flvPlayer!=null)
			{
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			}
			refreshBottomLocation();
		}
		private function refreshBottomLocation():void
		{
			MainSystem.getInstance().runAPIDirect("updateBottomMenu",[]);
		}
		private function init():void{
			
			fanZhuSangJiao=new FanZhuSangJiaoSwc();
			fanZhuSangJiao.tstext.gotoAndPlay(2);
			var tstime:Timer=new Timer(14000);
            tstime.start();
            tstime.addEventListener(TimerEvent.TIMER ,tstimef);
			addChild(fanZhuSangJiao);
			fanZhuSangJiao.guangHuang.x=50;	
			fanZhuSangJiao.guangHuang.y=10;
			fanZhuSangJiao.guangHuang.scaleX=1.5;
			fanZhuSangJiao.fzBotton.buttonMode=true;
			fanZhuSangJiao.fzBotton.addEventListener(MouseEvent.CLICK,fz_btCL);
			fanZhuSangJiao.fz_gx.buttonMode=true;
			fanZhuSangJiao.clound.mouseEnabled=false;
			fanZhuSangJiao.fz_gx.addEventListener(MouseEvent.CLICK,fz_gxCL);
			fanZhuSangJiao.fz_yunng.addEventListener(MouseEvent.MOUSE_OVER,fzyunnO);
			fanZhuSangJiao.fz_yunng.addEventListener(MouseEvent.MOUSE_OUT,fzyunnU);
			fanZhuSangJiao.fz_gzg.addEventListener(MouseEvent.MOUSE_OVER,fzgzO);
			fanZhuSangJiao.fz_gzg.addEventListener(MouseEvent.MOUSE_OUT,fzgzU);
			fanZhuSangJiao.fz_scg.addEventListener(MouseEvent.MOUSE_OVER,fzscO);
			fanZhuSangJiao.fz_scg.addEventListener(MouseEvent.MOUSE_OUT,fzscU);
			fanZhuSangJiao.fz_hng.addEventListener(MouseEvent.MOUSE_OVER,fzhnO);
			fanZhuSangJiao.fz_hng.addEventListener(MouseEvent.MOUSE_OUT,fzhnU);
			fanZhuSangJiao.fz_jxg.addEventListener(MouseEvent.MOUSE_OVER,fzjxO);
			fanZhuSangJiao.fz_jxg.addEventListener(MouseEvent.MOUSE_OUT,fzjxU);
			fanZhuSangJiao.fz_gdg.addEventListener(MouseEvent.MOUSE_OVER,fzgdO);
			fanZhuSangJiao.fz_gdg.addEventListener(MouseEvent.MOUSE_OUT,fzgdU);
            fanZhuSangJiao.fz_hnang.addEventListener(MouseEvent.MOUSE_OVER,fzhnanO);
            fanZhuSangJiao.fz_hnang.addEventListener(MouseEvent.MOUSE_OUT,fzhnanU);
            fanZhuSangJiao.fz_omg.addEventListener(MouseEvent.MOUSE_OVER,fzomO);
            fanZhuSangJiao.fz_omg.addEventListener(MouseEvent.MOUSE_OUT,fzomU);
            fanZhuSangJiao.fz_xgg.addEventListener(MouseEvent.MOUSE_OVER,fzxgO);
            fanZhuSangJiao.fz_xgg.addEventListener(MouseEvent.MOUSE_OUT,fzxgU);
            fanZhuSangJiao.fz_fjg.addEventListener(MouseEvent.MOUSE_OVER,fzfjO);
            fanZhuSangJiao.fz_fjg.addEventListener(MouseEvent.MOUSE_OUT,fzfjU);
	
			
		}
		private function fz_btCL(e:MouseEvent):void{
             trace("泛珠介绍弹窗");
		}
		private function backGuangXi():void{
			flvPlayer=new FLVPlayer("movie/gx-fz1.flv",900,480,false);
			this.addChild(flvPlayer);
            refreshBottomLocation();
			flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,gx_play_complete);
		}
		private function gx_play_complete(e:NetStatusEvent):void{
			 MainSystem.getInstance().showPluginById("ZongHengSiHaiModule");
			 if(flvPlayer!=null)
			 {
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			 }
			refreshBottomLocation();
			 
		}
		
		
		private function fz_gxCL(e:MouseEvent):void{
			
			backGuangXi();
            
		}
		private function fzyunnO(e:MouseEvent):void{
			fanZhuSangJiao.fz_yunn.gotoAndPlay(2);
		}
		private function fzyunnU(e:MouseEvent):void{
			fanZhuSangJiao.fz_yunn.gotoAndPlay(6);
		}
		private function fzgzO(e:MouseEvent):void{
			fanZhuSangJiao.fz_gz.gotoAndPlay(2);
		}
		private function fzgzU(e:MouseEvent):void{
			fanZhuSangJiao.fz_gz.gotoAndPlay(6);
		}
		private function fzscO(e:MouseEvent):void{
			fanZhuSangJiao.fz_sc.gotoAndPlay(2);
		}
		private function fzscU(e:MouseEvent):void{
			fanZhuSangJiao.fz_sc.gotoAndPlay(6);
		}
		private function fzhnO(e:MouseEvent):void{
			fanZhuSangJiao.fz_hn.gotoAndPlay(2);
		}
		private function fzhnU(e:MouseEvent):void{
			fanZhuSangJiao.fz_hn.gotoAndPlay(6);
		}
		private function fzjxO(e:MouseEvent):void{
			fanZhuSangJiao.fz_jx.gotoAndPlay(2);
		}
		private function fzjxU(e:MouseEvent):void{
			fanZhuSangJiao.fz_jx.gotoAndPlay(6);
		}

		private function fzgdO(e:MouseEvent):void{
			fanZhuSangJiao.fz_gd.gotoAndPlay(2);
		}
		private function fzgdU(e:MouseEvent):void{
			fanZhuSangJiao.fz_gd.gotoAndPlay(6);
		}
		private function fzhnanO(e:MouseEvent):void{
			fanZhuSangJiao.fz_hnan.gotoAndPlay(2);
		}
		private function fzhnanU(e:MouseEvent):void{
			fanZhuSangJiao.fz_hnan.gotoAndPlay(6);
		}
		private function fzomO(e:MouseEvent):void{
			fanZhuSangJiao.fz_om.gotoAndPlay(2);
		}
		private function fzomU(e:MouseEvent):void{
			fanZhuSangJiao.fz_om.gotoAndPlay(6);
		}
		private function fzxgO(e:MouseEvent):void{
			fanZhuSangJiao.fz_xg.gotoAndPlay(2);
		}
		private function fzxgU(e:MouseEvent):void{
			fanZhuSangJiao.fz_xg.gotoAndPlay(6);
		}
		private function fzfjO(e:MouseEvent):void{
			fanZhuSangJiao.fz_fj.gotoAndPlay(2);
		}
		private function fzfjU(e:MouseEvent):void{
			fanZhuSangJiao.fz_fj.gotoAndPlay(6);
		}
		private function tstimef(e:TimerEvent):void{
			fanZhuSangJiao.tstext.gotoAndPlay(2);
		}
		
		
		
		
		
		

	}
}
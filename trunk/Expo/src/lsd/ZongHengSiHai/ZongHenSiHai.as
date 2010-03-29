package lsd.ZongHengSiHai
{
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	import lxfa.view.player.FLVPlayer;
	import lxfa.view.player.FLVPlayerEvent;
	import lxfa.view.tool.ToolTip;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;

	public class ZongHenSiHai extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var flvPlayer:FLVPlayer;
		private var loading_mc:LoadingWaveRota;
		private var loading_mb:LoadingWaveRota;
		private var unrealCompassSwc:UnrealCompassSwc;
		public function ZongHenSiHai(withMovie:Boolean)
		{   
			MainSystem.getInstance().dispatcherPluginUpdate();
			MainSystem.getInstance().dispatcherSceneChangeInit(5);
			MainSystem.getInstance().stopRender();
			addZongHengSiHai(withMovie);
			
		}
		private function on_plugin_update():void
		{
			MainSystem.getInstance().runAPIDirectDirectly("removePluginById",[ZongHengSiHaiStatic.getInstance().currentModuleName]);
		}
		public function addZongHengSiHai(withMovie:Boolean):void{
			if(withMovie)
			{   MainSystem.getInstance().isBusy=true;
				initPlayer();
			}else
			{   
				MainSystem.getInstance().isBusy=true;
				init();
			}
			
		}
		private function initPlayer():void
		{
			flvPlayer=new FLVPlayer("movie/donggu.flv",900,480,false);
			addChild(flvPlayer);
			flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE,on_gx_complete);
	        flvPlayer.resume();
			flvPlayer.addEventListener(NetStatusEvent.NET_STATUS,on_Complete);
		}
		private function on_gx_complete(e:FLVPlayerEvent):void
		{   
			
			//MainSystem.getInstance().addAutoClose(on_plugin_update,[]);
		}
		private function flvRemove():void
		{
		     MemoryRecovery.getInstance().gcFun(flvPlayer,FLVPlayerEvent.COMPLETE,on_gx_complete);
		     MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS,on_Complete);
		     MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS, gx_fz_Complete);
		     MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS, gx_dm_Complete);
		     MemoryRecovery.getInstance().gcFun(flvPlayer,NetStatusEvent.NET_STATUS, gx_dmg_Complete);
		     MemoryRecovery.getInstance().gcObj(flvPlayer,true);
		}
		private function on_Complete(e:Event):void
		{     
             init();
		}
        private function init():void{
			
			 swfPlayer=new SwfPlayer("swf/zongHengSiHai.swf",980,480);
             initLoadingMc();
			 swfPlayer.addEventListener(ProgressEvent.PROGRESS,on_flv_progress);
			 swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
			 initUnrealCompass();
		}
		private function initUnrealCompass():void
		{
			unrealCompassSwc=new UnrealCompassSwc();
			unrealCompassSwc.scaleX=unrealCompassSwc.scaleY=0.5;
			unrealCompassSwc.x=360;
			unrealCompassSwc.y=340;
			unrealCompassSwc.buttonMode=true;
			unrealCompassSwc.addEventListener(MouseEvent.CLICK,on_unrealCompassSwc_click);
		}
		private function addAreas():void{
			
			 var daMeiGongHeArea:Array=[[[43,220],[157,301]]];
			 var dongMengArea:Array=[[[163,325],[282,395]]];
			 var fanZhuArea:Array=[[[580,296],[689,360]]];
			 var beiBuWanArea:Array=[[[326,342],[485,478]]];
			 var xiJiangArea:Array=[[[651,190],[734,220]]];
			 CollisionManager.getInstance().addCollision(dongMengArea,dongMengClick,"dongMeng");
			 CollisionManager.getInstance().addCollision(daMeiGongHeArea,daMeiGongHeClick,"daMeiGongHe");
			 CollisionManager.getInstance().addCollision(fanZhuArea,fanZhuClick,"fanzhu");
			 CollisionManager.getInstance().addCollision(beiBuWanArea,beiBuWanClick,"beiBuWan");
			 CollisionManager.getInstance().addCollision(xiJiangArea,xiJiangClick,"xiJiang");
		}
		
		
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			loading_mb=new LoadingWaveRota();
			loading_mb.x=450;
			loading_mb.y=230;
			addChild(Toolyzhkof.mcToUI(loading_mb));
			this.addEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
		}
		private function on_added_to_stage(e:Event):void
		{
			loading_mc.x=this.stage.stageWidth/2;
			loading_mc.y=this.stage.stageHeight/2;
			Application.application.addChild(Toolyzhkof.mcToUI(loading_mc));
		}
		private function on_flv_progress(e:ProgressEvent):void//FLV加载完毕
		{
			loading_mc.updateByProgressEvent(e);
			loading_mb.updateByProgressEvent(e);
		}
		private function on_swf_complete(e:Event):void
		{   
			this.removeEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
			MemoryRecovery.getInstance().gcObj(loading_mc);
			MemoryRecovery.getInstance().gcObj(loading_mb);
			flvRemove();
			this.addChild(swfPlayer);
			this.addChild(unrealCompassSwc);
			ToolTip.init(this);
			ToolTip.register(unrealCompassSwc,"杨梦八桂");
			addAreas();
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().dispatcherSceneChangeComplete(5);
			MainSystem.getInstance().addSceneChangeCompleteHandler(on_plugin_update,[]);
			MainSystem.getInstance().addSceneChangeInitHandler(function():void{
				removeAreas();
				if(unrealCompassSwc!=null)
				{
					unrealCompassSwc.visible=false;
				}
			},[]);
		}
        private function daMeiGongHeClick():void
		{
			    removeAreas();
			    MainSystem.getInstance().isBusy=true;
			    flvPlayer=new FLVPlayer("movie/gx-mgh1.flv", 900, 480, false);
				addChild(flvPlayer);
				flvPlayer.resume();
				flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_ymbg_Complete);
		}
		private function gx_ymbg_Complete(e:NetStatusEvent):void
		{
			gx_to_other_complete("DaMeiGongHeModule");
		}
       private function on_unrealCompassSwc_click(e:MouseEvent):void
		{
				trace("杨梦八桂");
			    removeAreas();
			    MainSystem.getInstance().isBusy=true;
			    flvPlayer=new FLVPlayer("movie/zonghengsihai-yangmengbagui.flv", 900, 480, false);
				addChild(flvPlayer);
				flvPlayer.resume();
				flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_dmg_Complete);
		}
		private function gx_dmg_Complete(e:NetStatusEvent):void
		{  
			MemoryRecovery.getInstance().gcFun(unrealCompassSwc,MouseEvent.CLICK,on_unrealCompassSwc_click);
		    gx_to_other_complete("YangMengBaGuiModule");
		}
		
        private function dongMengClick():void
		{
				trace("dongmeng");
				removeAreas();
			    MainSystem.getInstance().isBusy=true;
			    flvPlayer=new FLVPlayer("movie/gx-dm1.flv", 900, 480, false);
			    addChild(flvPlayer);
			    flvPlayer.resume();
			    flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_dm_Complete);
				
		}
		private function gx_dm_Complete(e:NetStatusEvent):void
		{  
			gx_to_other_complete("DongMengModule");
		}
		private function fanZhuClick():void
		{
			   trace("fanzhu");
			   removeAreas();
			   MainSystem.getInstance().isBusy=true;
			   flvPlayer=new FLVPlayer("movie/gx-fz1.flv", 900, 480, false);
			   addChild(flvPlayer);
			   flvPlayer.resume();
			   flvPlayer.addEventListener(NetStatusEvent.NET_STATUS, gx_fz_Complete);	
		}

		private function gx_fz_Complete(e:NetStatusEvent):void
		{  
			gx_to_other_complete("FanZhuSanJiaoModule");
		}
		//纵横四海到其他子场景时，电影播放完毕的操作
		private function gx_to_other_complete(moduleName:String):void
		{
			swfPlayer.visible=false;
			MainSystem.getInstance().isBusy=false;
			MainSystem.getInstance().showPluginById(moduleName);
		}
		private function beiBuWanClick():void
		{
				trace("beibuwan");
		}
		private function xiJiangClick():void
		{
				trace("xiJiang");
		}
		private function removeAreas():void{
			
			
			CollisionManager.getInstance().removeCollision("dongMeng");
			CollisionManager.getInstance().removeCollision("daMeiGongHe");
			CollisionManager.getInstance().removeCollision("fanzhu");
			CollisionManager.getInstance().removeCollision("beiBuWan");
			CollisionManager.getInstance().removeCollision("xiJiang");
			
		}
	
         public function dispose():void
         {  
         	removeAreas();
         	MemoryRecovery.getInstance().gcFun(unrealCompassSwc,MouseEvent.CLICK,on_unrealCompassSwc_click);
         	MemoryRecovery.getInstance().gcObj(unrealCompassSwc);
         	MemoryRecovery.getInstance().gcFun(swfPlayer,ProgressEvent.PROGRESS,on_flv_progress);
         	MemoryRecovery.getInstance().gcFun(swfPlayer,Event.COMPLETE,on_swf_complete);
         	MemoryRecovery.getInstance().gcObj(swfPlayer,true);
         	flvRemove();
         	
           
         }
	}
}
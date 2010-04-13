package plugins.lxfa.No3Swf.view
{
	import caurina.transitions.Tweener;
	
	import core.manager.MainSystem;
	import core.manager.musicManager.BackGroundMusicManager;
	import core.manager.pluginManager.PluginManager;
	import core.manager.pluginManager.event.PluginEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import memory.MemoryRecovery;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import view.ToolTip;
	import view.loadings.LoadingWaveRota;
	import view.player.SwfPlayer;
	
	public class No3SwfBase extends UIComponent
	{
		private var flowerFlvSwf:SwfPlayer;
		private var loading_mc:LoadingWaveRota;//用于显示进度
		private var unrealCompassSwc:UnrealCompassSwc;
		public function No3SwfBase()
		{
			MainSystem.getInstance().isBusy=true;
			initLoadingMc();//初始化LOADING_MC
			flowerFlvSwf=new SwfPlayer("swf/no3.swf",900,480);
			flowerFlvSwf.addEventListener(Event.COMPLETE,onComplete);
			flowerFlvSwf.x=-200;
			flowerFlvSwf.y=-100;
			flowerFlvSwf.addEventListener(ProgressEvent.PROGRESS,on_progress);
			unrealCompassSwc=new UnrealCompassSwc();
			unrealCompassSwc.scaleX=unrealCompassSwc.scaleY=0.4;
			unrealCompassSwc.x=130;
			unrealCompassSwc.y=300;
			unrealCompassSwc.buttonMode=true;
		}
		private function on_progress(e:ProgressEvent):void
		{
			loading_mc.updateByProgressEvent(e);//更新显示的进度
		}
		//进度
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			this.addChild(loading_mc);//添加到Application，这样才可以覆盖插件
			loading_mc.x=Application.application.width/2-200;
			loading_mc.y=Application.application.height/2-170;
		}
		private function onComplete(e:Event):void
		{
			this.removeChild(loading_mc);
			loading_mc=null;
			this.addChild(flowerFlvSwf);
			this.addChild(unrealCompassSwc);
			ToolTip.init(this);
			ToolTip.register(unrealCompassSwc,"绿色家园");
			unrealCompassSwc.addEventListener(MouseEvent.CLICK,onClick);
			Tweener.addTween(flowerFlvSwf,{alpha:1,time:3});
			MainSystem.getInstance().isBusy=false;
            MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
			BackGroundMusicManager.getInstance().loadBackGroundMusic("http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg1.mp3");
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			MainSystem.getInstance().addSceneChangeCompleteHandler(removeCurrentModule,[]);
			MainSystem.getInstance().removePluginById("No3Module");
		}
		private var hasClick:Boolean=false;
		private function onClick(e:MouseEvent):void
		{
			if(!MainSystem.getInstance().isBusy && !hasClick)
			{
				MainSystem.getInstance().showPluginById("No4Module");
				MemoryRecovery.getInstance().gcFun(unrealCompassSwc,MouseEvent.CLICK,onClick);
			}
		}
		private function removeCurrentModule():void
		{
			 PluginManager.getInstance().removePluginById("No3SwfModule");
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(unrealCompassSwc,MouseEvent.CLICK,onClick);
			if(unrealCompassSwc.parent!=null)
			{
				unrealCompassSwc.parent.removeChild(unrealCompassSwc);
			}
			unrealCompassSwc=null;
			MemoryRecovery.getInstance().gcFun(flowerFlvSwf,ProgressEvent.PROGRESS,on_progress);
			MemoryRecovery.getInstance().gcFun(flowerFlvSwf,Event.COMPLETE,onComplete);
			flowerFlvSwf.enabled=false;
			flowerFlvSwf.dispose();
		    if(flowerFlvSwf.parent!=null)
		    {
		    	flowerFlvSwf.parent.removeChild(flowerFlvSwf);
		    }
		    flowerFlvSwf=null;
		}
	}
}
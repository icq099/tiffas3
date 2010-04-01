package lxfa.No3Swf.view
{
	import caurina.transitions.Tweener;
	
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.BackGroundMusicManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	import lxfa.view.tool.ToolTip;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;
	
	public class No3SwfBase extends UIComponent
	{
		private var flowerFlvSwf:SwfPlayer;
		private var loading_mc:LoadingWaveRota;//用于显示进度
		private var unrealCompassSwc:UnrealCompassSwc;
		public function No3SwfBase()
		{
			MainSystem.getInstance().isBusy=true;
			initLoadingMc();//初始化LOADING_MC
			flowerFlvSwf=new SwfPlayer("movie/外馆效果.swf",900,480);
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
			this.addEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
		}
		private function on_added_to_stage(e:Event):void
		{
			loading_mc.x=this.stage.stageWidth/2;
			loading_mc.y=this.stage.stageHeight/2;
			Application.application.addChild(Toolyzhkof.mcToUI(loading_mc));//添加到Application，这样才可以覆盖插件
		}
		private function onComplete(e:Event):void
		{
			MemoryRecovery.getInstance().gcObj(loading_mc);//下载完毕的时候回收LOADING_MC
			this.addChild(flowerFlvSwf);
			this.addChild(unrealCompassSwc);
			ToolTip.init(this);
			ToolTip.register(unrealCompassSwc,"绿色家园");
			unrealCompassSwc.addEventListener(MouseEvent.CLICK,onClick);
			Tweener.addTween(flowerFlvSwf,{alpha:1,time:3});
			MainSystem.getInstance().isBusy=false;
            MainSystem.getInstance().showPluginById("MainMenuBottomModule");
			MainSystem.getInstance().showPluginById("MainMenuTopModule");
			MainSystem.getInstance().showPluginById("BackGroundMusicModule");
			BackGroundMusicManager.getInstance().loadBackGroundMusic("sound/bg1.mp3");
			MainSystem.getInstance().dispatchEvent(new PluginEvent(PluginEvent.UPDATE));
			MainSystem.getInstance().addSceneChangeCompleteHandler(dispose,[]);
			MainSystem.getInstance().removePluginById("No3Module");
		}
		private var hasClick:Boolean=false;
		private function onClick(e:MouseEvent):void
		{
			if(!MainSystem.getInstance().isBusy && !hasClick)
			{
				MainSystem.getInstance().showPluginById("No4Module");
				MemoryRecovery.getInstance().gcFun(unrealCompassSwc,MouseEvent.CLICK,onClick);
				MemoryRecovery.getInstance().gcObj(unrealCompassSwc);
			}
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(unrealCompassSwc,MouseEvent.CLICK,onClick);
			MemoryRecovery.getInstance().gcObj(unrealCompassSwc);
			MemoryRecovery.getInstance().gcFun(unrealCompassSwc,MouseEvent.CLICK,onClick);
			MemoryRecovery.getInstance().gcFun(flowerFlvSwf,ProgressEvent.PROGRESS,on_progress);
			MemoryRecovery.getInstance().gcFun(flowerFlvSwf,Event.COMPLETE,onComplete);
			MemoryRecovery.getInstance().gcFun(this,Event.ADDED_TO_STAGE,on_added_to_stage);
			flowerFlvSwf.enabled=false;
			Tweener.addTween(flowerFlvSwf,{alpha:0,time:3,onComplete:function():void{
			    MemoryRecovery.getInstance().gcObj(flowerFlvSwf,true);
			    MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["No3SwfModule"]);
			}});
		}
	}
}
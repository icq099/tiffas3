package plugins.lxfa.inquire
{
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.popupManager.CustomPopupManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import memory.MemoryRecovery;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class InquireBase extends UIComponent
	{
		private var inquireSwc:InquireSwc;
		private var inquireContainer:UIComponent;//仅仅是为了把能扔进PopManager
		private var animateParent:Canvas;//桂娃的父亲容器
		private var animate:DisplayObject//桂娃
		private var yesClickScript:String="";
		private var oldAnimatePosition:Point=new Point(0,0);
		public function InquireBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.CLEAR_YES_CLICK_SCRIPT,clearYesClickScript);
			ScriptManager.getInstance().addApi(ScriptName.ADD_YES_CLICK_SCRIPT,addYesClickScript);
			ScriptManager.getInstance().addApi(ScriptName.SHOW_INQUIRE,initInquireSwc);
		}
		private function initInquireSwc(id:int):void
		{
			CustomPopupManager.getInstance().dispacheShowEvent();
			inquireSwc=new InquireSwc();
			inquireContainer=new UIComponent();
			inquireContainer.addChild(inquireSwc);
	        //显示桂娃
	        ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[id]);
	        animate=PluginManager.getInstance().getPlugin("AnimateModule");
	        animateParent=Canvas(animate.parent);
	        oldAnimatePosition.x=animate.x;
	        oldAnimatePosition.y=animate.y;
	        animate.x=-300;
	        animate.y=20;
	        inquireContainer.addChild(animate);
			//POP出来
			PopUpManager.addPopUp(inquireContainer,DisplayObject(Application.application),true);
	        PopUpManager.centerPopUp(inquireContainer); 
	        //调整位置
	        inquireContainer.x=300;
	        inquireContainer.y=200;
	        //添加事件
	        inquireSwc.yes.addEventListener(MouseEvent.CLICK,on_yes_click);
	        inquireSwc.no.addEventListener(MouseEvent.CLICK,on_no_click);
		}
		private function addYesClickScript(script:String):void
		{
			script=ScriptManager.getInstance().filterScript(script);
			yesClickScript+=script;
		}
		private function clearYesClickScript():void
		{
			yesClickScript="";
		}
		//抛出打开下个场景的事件
		private function on_yes_click(e:MouseEvent):void
		{
			ScriptManager.getInstance().runScriptDirectly(yesClickScript);
			e.currentTarget.mouseEnabled=false;
			dispose();
			CustomPopupManager.getInstance().dispacheRemoveEvent();
		}
		//抛出关闭界面的事件
		private function on_no_click(e:MouseEvent):void
		{
			MainSystem.getInstance().isBusy=false;
			e.currentTarget.mouseEnabled=false;
			dispose();
			CustomPopupManager.getInstance().dispacheRemoveEvent();
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(inquireSwc,MouseEvent.CLICK,on_yes_click);
			MemoryRecovery.getInstance().gcFun(inquireSwc,MouseEvent.CLICK,on_no_click);
			if(inquireSwc!=null)
			{
				if(inquireSwc.parent!=null)
				{
					inquireSwc.parent.removeChild(inquireSwc);
				}
				inquireSwc=null;
			}
			if(animate!=null)
			{
				if(animate.parent!=null)
				{
					animate.parent.removeChild(animate);
				}
			}
			ScriptManager.getInstance().runScriptByName(ScriptName.REMOVE_ANIMATE,[]);
			animateParent.addChild(animate);
			animate.x=oldAnimatePosition.x;//恢复桂娃的位置
			animate.y=oldAnimatePosition.y;
			PopUpManager.removePopUp(inquireContainer);
			inquireContainer=null;
		}
	}
}
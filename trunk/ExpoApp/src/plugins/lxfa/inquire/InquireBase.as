package plugins.lxfa.inquire
{
	import core.manager.MainSystem;
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		public function InquireBase()
		{
			ScriptManager.getInstance().addApi(ScriptName.SHOWINQUIRE,initInquireSwc);
		}
		private function initInquireSwc(id:int):void
		{
			inquireSwc=new InquireSwc();
			inquireContainer=new UIComponent();
			inquireContainer.addChild(inquireSwc);
	        //显示桂娃
	        ScriptManager.getInstance().runScriptByName(ScriptName.ADDANIMATE,[id]);
	        animate=PluginManager.getInstance().getPlugin("AnimateModule");
	        animateParent=Canvas(animate.parent);
	        animate.x=-300;
	        animate.y=20;
	        inquireContainer.addChild(animate);
			//POP出来
			PopUpManager.addPopUp(inquireContainer,DisplayObject(Application.application), true);
	        PopUpManager.centerPopUp(inquireContainer); 
	        //调整位置
	        inquireContainer.x=300;
	        inquireContainer.y=200;
	        //添加事件
	        inquireSwc.yes.addEventListener(MouseEvent.CLICK,on_yes_click);
	        inquireSwc.no.addEventListener(MouseEvent.CLICK,on_no_click);
		}
		//抛出打开下个场景的事件
		private function on_yes_click(e:MouseEvent):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				this.dispatchEvent(new Event(Event.OPEN));
				e.currentTarget.mouseEnabled=false;
				dispose();
			}
		}
		//抛出关闭界面的事件
		private function on_no_click(e:MouseEvent):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				this.dispatchEvent(new Event(Event.CLOSE));
				e.currentTarget.mouseEnabled=false;
				dispose();
			}
		}
		public function dispose():void
		{
			PopUpManager.removePopUp(inquireContainer);
			inquireContainer=null;
			if(MainSystem.getInstance().isBusy!=true)
			{
				ScriptManager.getInstance().runScriptByName(ScriptName.REMOVEANIMATE,[]);
			}
			animateParent.addChild(animate);
		}
	}
}
package lxfa.inquire
{
	import communication.Event.ScriptAPIAddEvent;
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class InquireBase extends EventDispatcher
	{
		private var inquireSwc:InquireSwc;
		private var inquireContainer:UIComponent;//仅仅是为了把能扔进PopManager
		public function InquireBase()
		{
			MainSystem.getInstance().addAPI("showInquire",initInquireSwc);
			MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.ADD_API,on_api_add);
		}
		private function on_api_add(e:ScriptAPIAddEvent):void
		{
			MainSystem.getInstance().runAPIDirect("showInquire",[0]);
		}
		private function initInquireSwc(id:int):void
		{
			inquireSwc=new InquireSwc();
			inquireContainer=new UIComponent();
			inquireContainer.addChild(inquireSwc);
	        //显示桂娃
	        MainSystem.getInstance().runAPIDirect("addAnimate",[id]);
//	        var ui:UIComponent=new UIComponent();
//	        ui.addChild(MainSystem.getInstance().getPlugin("AnimateModule"));
//	        PopUpManager.addPopUp(ui,DisplayObject(Application.application),true);
//	        PopUpManager.centerPopUp(ui); 
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
			this.dispatchEvent(new Event(Event.OPEN));
		}
		//抛出关闭界面的事件
		private function on_no_click(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
	}
}
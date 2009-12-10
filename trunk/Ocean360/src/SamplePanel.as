package
{
	import assets.Panel1Handler;
	import assets.Panel2Handler;
	import assets.model.HotPointStructManager;
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import remoteobject.HotPointStruct;
	
	public class SamplePanel extends UIComponent
	{
		public var sp:SamplePanelBackGround=new SamplePanelBackGround();
		public var p1h:Panel1Handler;
		public var hps:HotPointStruct=new HotPointStruct();
		public var hpsm:HotPointStructManager=new HotPointStructManager(sp,hps);//所要上传的数据结构
		public function SamplePanel()
		{
			this.addChild(hpsm);
			addHandler();
			addButtonsEvent();
			stopAllButton();
			addSp();
			hideAllPanel();
			sp.panel1.visible=true;
		}
		//返回hotpoiotStruct
		public function getHotpointStruct():HotPointStruct
		{
			return hps;
		}
		//给各个界面的按钮添加监听器
		private function addHandler():void
		{
			p1h=new Panel1Handler(sp,hpsm);
			new Panel2Handler(sp,hps,hpsm);
		}

		//添加标本面板
		private function addSp():void
		{
			this.addChild(sp);
		}
		//移除标本面板
		private function removeSp():void
		{
			
		}
		private function addButtonsEvent():void
		{
			sp.button1.addEventListener(MouseEvent.CLICK,button1ClickEvent);
			sp.button2.addEventListener(MouseEvent.CLICK,button2ClickEvent);
		}
		//---------------------让所有按钮回复原状----------------
		private function resetAllButton():void
		{
			sp.button1.gotoAndStop("1");
			sp.button2.gotoAndStop("1");
		}
		//让所有按钮停止播放
		private function stopAllButton():void
		{
			sp.button1.stop();
			sp.button2.stop();
		}

		//让所有面板影藏
		private function hideAllPanel():void
		{
			sp.panel1.visible=false;
			sp.panel2.visible=false;
		}
		//-----------------------按钮点击事件--------------------
		private function button1ClickEvent(e:MouseEvent):void
		{
			resetAllButton();
			hideAllPanel();
			sp.panel1.visible=true;
			sp.button1.gotoAndStop("2");
		}
		private function button2ClickEvent(e:MouseEvent):void
		{
			resetAllButton();
			hideAllPanel();
			sp.panel2.visible=true;
			sp.button2.gotoAndStop("2");
		}
		
	}
}
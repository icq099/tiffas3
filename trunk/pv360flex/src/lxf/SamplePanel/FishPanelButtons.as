package lxf.SamplePanel
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class FishPanelButtons extends Sprite
	{
		
		private var fpb:FishPanelButton;
		private var textFieldLocationX:int=20;
		private var textFieldLocationY:int=5;
		private var buttonText:String=null;
		public var label:String="";
		public var icon:String="yes";
		public var hello:String="hello";
		public function FishPanelButtons(text:String)
		{
			this.buttonText=text;
			addButton();
			addTextField();
			label=text;
		}
		//添加按钮
		private function addButton():void
		{
			fpb=new FishPanelButton();
			fpb.stop();
			fpb.addEventListener(MouseEvent.MOUSE_OVER,addButtonOverEvent);
			fpb.addEventListener(MouseEvent.MOUSE_OUT,addButtonOutEvent);
			this.addChild(fpb);
		}
//		/添加说明文字
		private function addTextField():void 
		{
			var textStr:TextField=new TextField();
			textStr.selectable=false;
			textStr.x=textFieldLocationX;
			textStr.y=textFieldLocationY;
			textStr.text=this.buttonText;
			var format1:TextFormat=new TextFormat();
			format1.size=14;
			textStr.setTextFormat(format1);
			textStr.addEventListener(MouseEvent.MOUSE_OVER,addButtonOverEvent);
			textStr.addEventListener(MouseEvent.MOUSE_OUT,addButtonOutEvent);
			this.addChild(textStr);			
		}
		//按钮事件
		private function addButtonOverEvent(e:MouseEvent):void
		{
			fpb.gotoAndStop("2");
		}
		private function addButtonOutEvent(e:MouseEvent):void
		{
			fpb.gotoAndStop("1");
		}
	}
}
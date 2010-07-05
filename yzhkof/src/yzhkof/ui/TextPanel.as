package yzhkof.ui
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class TextPanel extends BackGroudContainer
	{
		private var textfield:TextField=new TextField;
		public function TextPanel(color:uint=0xffffff)
		{
			super(color);
			addChild(textfield);
			textfield.autoSize=TextFieldAutoSize.LEFT;
			textfield.selectable=false;
			textfield.mouseEnabled=false;
			buttonMode=true;
		}
		public function set text(value:String):void
		{
			if(text == value) return;
			textfield.text=value||"";
			commitChage("text");
		}
		public function get text():String
		{
			return textfield.text;
		}
	}
}
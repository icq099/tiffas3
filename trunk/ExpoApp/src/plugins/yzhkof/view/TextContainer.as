package plugins.yzhkof.view
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class TextContainer extends Sprite
	{
		protected var offset:Number=5;
		
		protected var panel:Sprite;
		
		public function TextContainer()
		{
			addChild(panel);
			contentText.selectable=false;
		}
		public function set text(value:String):void{
			
			contentText.text=value;
			contentText.autoSize=TextFieldAutoSize.CENTER;
			back.width=contentText.width+offset*2;
		
		}
		protected function set PanelClass(value:Class):void{
			
			panel=new value();
		
		};
		public function get text():String{
			
			return contentText.text;
		
		}
		private function get contentText():TextField{
			
			return panel.getChildByName("show_text") as TextField;
		
		}
		private function get back():Sprite{
			
			return panel.getChildByName("back") as Sprite;
		
		}
		
	}
}
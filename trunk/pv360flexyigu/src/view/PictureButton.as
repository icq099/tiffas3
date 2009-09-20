package view
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class PictureButton extends Sprite
	{
		[Embed (source="asset/Map.swf",symbol="PictureButton")]
		private static var PButton:Class;
		private var _p_button:Sprite=new PButton();
		public function PictureButton()
		{
			super();
			addChild(_p_button);
			numText.selectable=false;
			buttonMode=true;
			
		}
		public function set textNum(value:int):void{
			
			numText.text=String(value);
			
		}
		public function get numText():TextField{
			
			return _p_button.getChildByName("num_text") as TextField;
		
		}
		
	}
}
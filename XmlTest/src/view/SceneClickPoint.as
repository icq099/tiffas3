package view
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class SceneClickPoint extends TextContainer
	{		
		public function SceneClickPoint(text:String="")
		{
			
			PanelClass=ClickPointSkin;
			super();
			this.text=text;
			
		}
		
	}
}
package util
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	public class Tool
	{
		public static function mcToUI(mc:DisplayObject):UIComponent{
			var uicom:UIComponent=new UIComponent();
			uicom.addChild(mc);
			return uicom;
		} 
	}
}
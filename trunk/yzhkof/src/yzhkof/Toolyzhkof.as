package yzhkof
{
	import flash.display.DisplayObject;
	import flash.net.LocalConnection;
	
	import mx.core.UIComponent;
	
	public class Toolyzhkof
	{
		public static function mcToUI(mc:DisplayObject):UIComponent{
			
			var uicom:UIComponent=new UIComponent();
			uicom.addChild(mc);
			return uicom;
		
		} 


	}
}
package view.fl2mx
{
	import flash.display.DisplayObject;
	import flash.net.LocalConnection;
	
	import mx.core.UIComponent;
	
	public class Fl2Mx
	{
		public static function fl2Mx(mc:DisplayObject):UIComponent{
			var uicom:UIComponent=new UIComponent();
			uicom.addChild(mc);
			return uicom;
		} 
	}
}
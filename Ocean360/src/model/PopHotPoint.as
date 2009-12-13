package model
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import view.PopMenusFlex;
	
	public class PopHotPoint
	{
		public function PopHotPoint()
		{
		}
		public static function popUp(xml:XML):void{
			var menu:PopMenusFlex=PopUpManager.createPopUp(DisplayObject(Application.application),PopMenusFlex,true) as PopMenusFlex;
			var fun_close:Function=function(e:Event):void{
				PopUpManager.removePopUp(menu);
			}
			menu.addEventListener(FlexEvent.CREATION_COMPLETE,function(e:Event):void{
				menu.constructByXml(xml);
				menu.addEventListener(CloseEvent.CLOSE,fun_close);
			});	
			PopUpManager.centerPopUp(menu);
		}

	}
}
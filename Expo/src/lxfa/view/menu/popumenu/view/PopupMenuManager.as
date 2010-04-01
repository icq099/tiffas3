package lxfa.view.menu.popumenu.view
{
	import communication.MainSystem;
	
	import flash.events.MouseEvent;
	
	public class PopupMenuManager
	{
		private var popupMenuList:Object=new Object();
		private var popupMenuArray:Array=new Array();
		public function PopupMenuManager()
		{
		}
		public function init(obj:*,name:String,id:int):void
		{
			popupMenuList[name]=new PopupMenu(obj,id);
			popupMenuArray.push(popupMenuList[name]);
			obj.addEventListener(MouseEvent.MOUSE_OVER,over);
		}
		private function over(e:MouseEvent):void
		{
			removeAllPopupMenu();
			if(!MainSystem.getInstance().isBusy)
			{
				e.currentTarget.parent.addChild(popupMenuList[e.currentTarget.name]);
			}
		}
		private function removeAllPopupMenu():void
		{
			for each(var p:PopupMenu in popupMenuArray)
			{
				if(p!=null && p.parent!=null)
				{
					p.parent.removeChild(p);
				}
			}
		}
	}
}
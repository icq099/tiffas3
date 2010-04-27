package core.manager.popupManager
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class CustomPopupManager extends EventDispatcher
	{
		private var _num:int=0;//被pop出来的窗口的数目
		private static var _instance:CustomPopupManager;
		private var childList:Dictionary=new Dictionary(true);
		public function CustomPopupManager():void
		{
			if(_instance==null)
			{
				_instance=this;
			}else
			{
				throw new Error("CustomPopupManager不能被实例化");
			}
		}
		public static function getInstance():CustomPopupManager
		{
			if(_instance==null) return new CustomPopupManager();
			return _instance;
		}
		/**
		 * 显示指定的对象,要是第一次显示就抛出显示的事件，其他窗口监听到这个事件就自动停止工作
		 */
	    public function centerPopUp(popUp:IFlexDisplayObject):void
	    {
	        PopUpManager.centerPopUp(popUp);
	    	if(_num==0)//如果第一次显示就显示的事件
	    	{
	    		dispatchEvent(new PopupManagerEvent(PopupManagerEvent.SHOW_POPUP));
	    	}
	    	if(popUp!=null)//存储popup出来的对象，到时候还要核对
	    	{
	    		 _num++;
	    	}
	    	childList[popUp]=popUp;
	    }
		/**
		 * 添加对象进popupmanager,但保证不会出现两个model
		 */
	    public function addPopUp(window:IFlexDisplayObject):void
	    {
	    	if(_num==0)
	    	{
	    		PopUpManager.addPopUp(window, DisplayObject(Application.application), true, null);
	    	}else
	    	{
	    		PopUpManager.addPopUp(window, DisplayObject(Application.application), false, null);
	    	}
	    }
		/**
		 * 删除指定的对象，要是这个对象是最后一个，就抛出CustomPopupManagerEvent,其他窗口一检测到这个事件，就继续运行暂停的工作
		 */
	    public function removePopUp(popUp:IFlexDisplayObject):void
	    {
	    	if(childList[popUp]!=null)
	    	{
	    		childList[popUp]=null;
	    		PopUpManager.removePopUp(popUp);
	    		_num--;
	    	}
	    	if(_num==0)
	    	{
	    		dispatchEvent(new PopupManagerEvent(PopupManagerEvent.REMOVE_POPUP));//抛出关闭的事件
	    	}
	    }
	    public function get num():int{
	    	return _num;
	    }
	    /**
	     * 抛出显示的事件
	     * */
	    public function dispacheShowEvent():void
	    {
	    	dispatchEvent(new PopupManagerEvent(PopupManagerEvent.SHOW_POPUP));
	    }
	    /**
	     * 抛出关闭的事件
	     */
	    public function dispacheRemoveEvent():void
	    {
	    	dispatchEvent(new PopupManagerEvent(PopupManagerEvent.REMOVE_POPUP));
	    }
	}
}
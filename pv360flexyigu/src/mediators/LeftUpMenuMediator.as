package mediators
{
	import facades.FacadePv;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxys.PXml;
	
	import view.leftupmenu.Event.LeftUpMenuEvent;
	import view.leftupmenu.LeftUpMenuContainer;

	public class LeftUpMenuMediator extends Mediator
	{
		public static const NAME:String="LeftUpMenuMediator";
		
		private var xml_hot_points:XMLList;
		private var pxml:PXml;
		private var hot_points_array:Array=new Array();
		
		public function LeftUpMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
		}
		public override function listNotificationInterests():Array{
			
			return [
			
			FacadePv.LOAD_XML_COMPLETE
			
			];
		
		}
		public override function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				case FacadePv.LOAD_XML_COMPLETE:
				
					//initXml();
					initListener();
				
				break;
				
			}
		
		}
		public function get menuView():LeftUpMenuContainer{
			
			return viewComponent as LeftUpMenuContainer;
		
		}
		private function initListener():void{
			
			menuView.addEventListener(LeftUpMenuEvent.ITEM_CLICK,onItemClikHandler);
			//menuView.addEventListener(LeftUpMenuEvent.GO_CLICK,onGoClickHandler);
			//menuView.clickButton.addEventListener(MouseEvent.CLICK,onButtonClickHandler);
			//menuView.updateList(hot_points_array);
			//menuView.list.addEventListener(ListEvent.ITEM_CLICK,onItemClikHandler)
		
		}
		private function onItemClikHandler(e:LeftUpMenuEvent):void{
			
			facade.sendNotification(FacadePv.POPUP_MENU_DIRECT,e.id);
			//facade.sendNotification(FacadePv.POPUP_MENU_DIRECT,{num:e.rowIndex*menuView.list.columnCount+e.columnIndex,array:hot_points_array})
		
		}
		/* private function onGoClickHandler(e:LeftUpMenuEvent):void{
			
			facade.sendNotification(FacadePv.GO_POSITION,e.go);			
		
		} */
		private function onButtonClickHandler(e:Event):void{
			
		//	menuView.popUpMenu();
		
		}
		private function initXml():void{
			
			pxml=facade.retrieveProxy(PXml.NAME) as PXml;
			menuView.constructByXml(dealWithXml(pxml.getMenuXml()));
		}
		private function dealWithXml(xml:XML):XML{
			
			var t_xml:XMLList=xml.menu;
			
			var i:XML;
			var j:XML;
			var k:XML;
			
			for each(i in t_xml){
				
				for each(j in i.submenu){
					
					for each(k in j.item){
						
						k.@label=pxml.getHotPointXmlById(String(k.@id)).@name;
					
					}
				
				}
			
			}
			xml.menu=t_xml;
			return xml;
		
		}
		
	}
}
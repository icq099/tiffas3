package {
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.containers.Canvas;
	
	import util.Cover;
	
	import yzhkof.Toolyzhkof;
	//[SWF(width='800',height='600',backgroundColor="#ffffff",frameRate="30")]
	public class pv360project extends Canvas
	{
		
		private var loadingSimpleRota:Class;
		public function pv360project()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
			
		}
		private function init(e:Event):void{
			
			//KeyMy.setStage(this.stage);
			addChild(new Pv360Application());
			//FPSfromA3d.init(stage)
			addChild(Toolyzhkof.mcToUI(new Cover(this)));
			var c_menu:ContextMenu=new ContextMenu();
			c_menu.hideBuiltInItems();
			var item:ContextMenuItem= new ContextMenuItem("LLLQW");
			c_menu.customItems.push(item);
			contextMenu=c_menu;
		
		}
	}
}

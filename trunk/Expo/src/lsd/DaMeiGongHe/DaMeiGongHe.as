package lsd.DaMeiGongHe
{
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	
	import mx.core.UIComponent;
	public class DaMeiGongHe extends UIComponent
	{   
		private var swfPlayer:SwfPlayer;
		
		public function DaMeiGongHe()
		{
			init();
		}
		private function init():void{
			swfPlayer=new SwfPlayer("swf/dameigonghe.swf",900,480);
			this.addChild(swfPlayer);
			var guangXiArea:Array=[[[485,129],[610,183]]];
			var daMeiGongHeWindowArea:Array=[[[670,185],[880,222]]];
			CollisionManager.getInstance().addCollision(guangXiArea,guangXiClick,"dmg_gx");
			CollisionManager.getInstance().addCollision(daMeiGongHeWindowArea,daMeiGongHeWindowClick,"daMeiGongHeWindow");
			CollisionManager.getInstance().showCollision();
			
		}
	   private function guangXiClick():void{
			trace("guangxi");
		}
		private function daMeiGongHeWindowClick():void{
			trace("dameigonghewindow");
		}
		public function dispose():void{
			
		}
		
		
	}
}
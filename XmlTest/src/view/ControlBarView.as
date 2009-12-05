package view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	public class ControlBarView extends Sprite
	{
		[Embed (source="asset/Map.swf",symbol="ControlBar")]
		private static var ControlBar:Class;
		
		private var control_bar:Sprite;
		
		public function ControlBarView()
		{
			init();
		}
		public function getUpButton():SimpleButton{
			
			return control_bar.getChildByName("up") as SimpleButton;
		
		}
		public function getDownButton():SimpleButton{
			
			return control_bar.getChildByName("down") as SimpleButton;
		
		}
		public function getLeftButton():SimpleButton{
			
			return control_bar.getChildByName("left") as SimpleButton;
		
		}
		public function getRightButton():SimpleButton{
			
			return control_bar.getChildByName("right") as SimpleButton;
		
		}
		
		public function getPlusButton():SimpleButton{
			
			return control_bar.getChildByName("plus") as SimpleButton;
		}
		
		public function getMinusButton():SimpleButton{
			
			return control_bar.getChildByName("minus") as SimpleButton;
		}
		private function init():void{
			
			control_bar=new ControlBar();
			addChild(control_bar);
		
		}
		
		
	}
}
package plugins.yzhkof.view.player
{
	import flash.events.Event;

	public class PlayerBottomControler extends PlayerControlMC
	{
		private const RIGHT:Number=200;
				
		public function PlayerBottomControler()
		{
			super();
		}
		override public function set width(value:Number):void{
			
			back.width=value;
			time_text.x=back.width-RIGHT;
		}
		override public function get width():Number{
			
			return back.width;
		
		}
		override public function set height(value:Number):void{
			
			back.height=value;
		
		}
		override public function get height():Number{
			
			return back.height;
		
		}
		public function setLeft_ButtonsVisible(visible:Boolean):void
		{
			this.left_buttons.visible=visible;
		}
	}
}
package view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	public class SubTitleBase extends Sprite
	{
		private var skin:Sprite;
		
		public function SubTitleBase()
		{
			super();
			addChild(skin);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		public function set text(text:String):void{
			
			show_text.text=text;
			show_text.scrollH=0;
		
		}
		protected function set SkinClass(value:Class):void{
			
			skin=new value();
		
		}
		protected function get show_text():TextField{
			
			return skin.getChildByName("show_text") as TextField;
		
		}
		private function onEnterFrame(e:Event):void{
			
			show_text.scrollH+=1;
			if(show_text.scrollH>=show_text.maxScrollH){
					
					show_text.scrollH=0;
				
			}
		
		}
		
	}
}
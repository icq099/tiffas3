package view
{
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	public class SubTitle extends SubTitleSkin
	{
		public function SubTitle()
		{
			super();
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		public function set text(text:String):void{
			
			show_text.text=text;
			show_text.scrollH=0;
		
		}
		private function onEnterFrame(e:Event):void{
			
			show_text.scrollH+=1;
			if(show_text.scrollH>=show_text.maxScrollH){
					
					show_text.scrollH=0;
				
			}
		
		}
		
	}
}
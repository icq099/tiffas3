package yzhkof.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import yzhkof.MyGraphy;

	public class TextTrace extends Sprite
	{
		private static const text_info:TextField=new TextField();
		private static const container:Sprite=new Sprite();
		private static const drag_btn:Sprite=MyGraphy.drawRectangle(20,20);
		private static const scaleX_btn:Sprite=MyGraphy.drawRectangle(20,20);
		
		private static const text_width:Number=600;
		private static const text_height:Number=50;
		
		private static const back:Sprite=MyGraphy.drawRectangle(text_width+21,text_height,true,0xffffff);
		
		
		public function TextTrace()
		{
			super();
			
		}
		public static function init(dobj:DisplayObjectContainer):DisplayObjectContainer{
			
			drag_btn.buttonMode=true;
			scaleX_btn.buttonMode=true;
			scaleX_btn.x=text_width+21;
			scaleX_btn.y=text_height-20;
			
			text_info.width=text_width;
			text_info.height=text_height;
			text_info.x=21;
			
			container.addChild(back);
			container.addChild(scaleX_btn);
			container.addChild(drag_btn);
			container.addChild(text_info);
			dobj.addChild(container);
			
			drag_btn.addEventListener(MouseEvent.MOUSE_DOWN,containerMouseDownHandler);
			drag_btn.addEventListener(MouseEvent.MOUSE_UP,containerMouseUpHandler);
			
			scaleX_btn.addEventListener(MouseEvent.MOUSE_DOWN,scaleXMouseDownHandler);
			scaleX_btn.addEventListener(MouseEvent.MOUSE_UP,scaleXMouseUpHandler);
			
			return dobj;
		
		
		}
		public static function textPlus(str:String):void{
			
			text_info.appendText(str);
			text_info.scrollV=text_info.maxScrollV;
		
		}
		public static function textClean():void{
			
			text_info.text=null;
		
		}
		private static function scaleXMouseDownHandler(e:Event):void{
			
			scaleX_btn.startDrag();
			scaleXonEnterFrame(null);
			scaleX_btn.addEventListener(Event.ENTER_FRAME,scaleXonEnterFrame);
		
		}
		private static function scaleXMouseUpHandler(e:Event):void{
			
			scaleX_btn.removeEventListener(Event.ENTER_FRAME,scaleXonEnterFrame);
			scaleXonEnterFrame(null);
			scaleX_btn.stopDrag();
		
		}
		private static function scaleXonEnterFrame(e:Event):void{
			
			text_info.width+=scaleX_btn.x-text_info.width-20;
			back.width+=scaleX_btn.x-back.width;
			text_info.height+=scaleX_btn.y-text_info.height+20;
			back.height+=scaleX_btn.y-back.height+20;
		
		}
		private static function containerMouseDownHandler(e:Event):void{
			
			container.startDrag();
		
		}
		private static function containerMouseUpHandler(e:Event):void{
			
			container.stopDrag();
		
		}
		
		
	}
}
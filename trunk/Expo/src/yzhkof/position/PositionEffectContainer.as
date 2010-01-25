package yzhkof.position
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	
	import yzhkof.ToolBitmapData;

	public class PositionEffectContainer extends Sprite
	{
		public static const TYPE_NORMAL:String="normal";
		public static const TYPE_REVERSE:String="reverse";
		private var type:String;
		private var size:int;
		private var text:String;
		private var textfield:TextField=new TextField();
		private var bitmap_arr:Array;//type bitmap;
		private var textFormat:TextFormat;
		//private const offset:Number=5;
		public function PositionEffectContainer(text:String,type:String="normal",size:int=43)
		{
			super();
			this.text=text;
			this.type=type;
			this.size=size;
			init();
			initDisplayObject();
		}
		private function init():void{
			textfield.autoSize=TextFieldAutoSize.LEFT;
			textFormat=new TextFormat();
			textFormat.size=size;
			textFormat.color=0xffffffff;
			textfield.filters=[new GlowFilter(0x88ffffff,0.5,10,10,2,3)];
		}
		private function initDisplayObject():void{
			bitmap_arr=getBitmapdataArray();
			for(var i:int=0;i<bitmap_arr.length;i++){
				addChild(Bitmap(bitmap_arr[i]));
				if(i>0){
					bitmap_arr[i].x=bitmap_arr[i-1].x+bitmap_arr[i-1].width;
				}
			}
			for(i=0;i<bitmap_arr.length;i++){
				switch(type){
					case TYPE_NORMAL:
						TweenLite.from(bitmap_arr[i],0.7,{alpha:0,x:String(-bitmap_arr[i].width/2),width:0,delay:i*0.2});
					break;
					case TYPE_REVERSE:
						TweenLite.from(bitmap_arr[i],0.7,{alpha:0,x:String(-bitmap_arr[i].width/2),width:0,delay:(bitmap_arr.length-i-1)*0.2});
					break;
				}
			}
		}
		private function getBitmapdataArray():Array{
			var re_arr:Array=new Array();
			for(var i:int=0;i<text.length;i++){
				textfield.htmlText="<b>"+text.charAt(i)+"</b>";
				textfield.setTextFormat(textFormat);
				re_arr.push(new Bitmap(ToolBitmapData.getInstance().drawDisplayObject(textfield)));
			}
			return re_arr;
		}
		public function dispose():void{
			for(var i:int=0;i<bitmap_arr.length;i++){
				Bitmap(bitmap_arr[i]).bitmapData.dispose();
			}
		}
	}
}
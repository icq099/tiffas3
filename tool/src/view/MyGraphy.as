package view
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class MyGraphy
	{
		public function MyGraphy()
		{
			throw new Error("无法被实例化");
			
		}
		public static function drawRectangle(width:Number=100,height:Number=100,is_fill:Boolean=true,colour:uint=0x000000):Sprite{
			
			var re_obj:Sprite=new Sprite();
			re_obj.graphics.lineStyle(1,colour);
			if(is_fill){
				re_obj.graphics.beginFill(colour);
			}
			re_obj.graphics.drawRect(0,0,width,height);
			re_obj.graphics.endFill();
			
			return re_obj;
			
		}
		/* public static function getTextBitmapData(textField:TextField):BitmapData{
			var bitmap:BitmapData;
			bitmap=new BitmapData(textField.width,textField.height,true,0x00000000);
			bitmap.draw(textField,textField.transform.matrix);
			return bitmap;
		} */
	}
}
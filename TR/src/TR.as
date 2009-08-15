package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import tiff.Tiff;
	public class TR extends Sprite
	{
		private var loader:URLLoader; 
		public function TR()
		{
			loader=new URLLoader(new URLRequest("cenfax_1245134002_519_0.tiff"));//读取图片
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,LoaderCompleteEvent);
		}
		private function LoaderCompleteEvent(e:Event):void{
			var byte:ByteArray=loader.data;
			var t:Tiff=new Tiff
			t.read(byte);//载入图片数据		
			var b:Bitmap=new Bitmap(t.getImage(0))//返回图片,0为页数
			addChild(b);
		}
	}
}

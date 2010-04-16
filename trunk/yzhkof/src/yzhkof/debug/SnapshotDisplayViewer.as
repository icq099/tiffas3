package yzhkof.debug
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import yzhkof.ToolBitmapData;

	public class SnapshotDisplayViewer extends Sprite
	{
		private var bitmap:Bitmap;
		private var bitmapdata:BitmapData;
		private var source:DisplayObject;
		public function SnapshotDisplayViewer()
		{
			super();
			bitmap=new Bitmap();
			addChild(bitmap);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		public function view(dobj:DisplayObject):void
		{
			source=dobj;
			bitmap.smoothing=true;
			onEnterFrame(null);
		}
		private function onEnterFrame(e:Event):void
		{
			if(source&&visible)
			{
				if(bitmapdata!=null)
					bitmapdata.dispose();
				bitmapdata=ToolBitmapData.getInstance().drawDisplayObject(source)
				if(bitmapdata!=null)
				{
					bitmap.bitmapData=bitmapdata;
				}
			}
		}
		
	}
}
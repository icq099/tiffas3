package yzhkof
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class ToolBitmapData
	{
		private static var instance:ToolBitmapData;
		
		public function ToolBitmapData()
		{
			if(instance!=null) throw new Error("ToolBitmapData Singleton already constructed!");
			instance=this;
		}
		public static function getInstance():ToolBitmapData{
			
			if(instance==null) instance=new ToolBitmapData();
			return instance;
		
		}
		public function drawDisplayObject(obj:DisplayObject=null):BitmapData{
		
			var bitmapdata:BitmapData=new BitmapData(obj.width,obj.height,true,0);
			var rect:Rectangle=obj.getBounds(obj);
			var matrix:Matrix=new Matrix();
			matrix.translate(-rect.x,-rect.y);
			bitmapdata.draw(obj,matrix);
			return bitmapdata;
		
		}

	}
}
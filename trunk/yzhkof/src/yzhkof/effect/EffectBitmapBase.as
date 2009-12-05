package yzhkof.effect
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import yzhkof.ToolBitmapData;

	public class EffectBitmapBase extends EffectBase
	{
		protected var effector_bitmap:Bitmap;
		public function EffectBitmapBase(container:DisplayObjectContainer, effector:DisplayObject)
		{
			super(container, effector);
		}
		public override function start():void{
			effector_bitmap=new Bitmap(ToolBitmapData.getInstance().drawDisplayObject(effector));
			super.start();
		}
		
	}
}
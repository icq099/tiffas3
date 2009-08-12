package
{
	import flash.display.Sprite;
	
	import yzhkof.BytesUtil;

	public class byte extends Sprite
	{
		public function byte()
		{
			super();
			var a:uint=204;
			var b:Array=BytesUtil.bytePerBit(a);
			trace(b);
		}
		
	}
}
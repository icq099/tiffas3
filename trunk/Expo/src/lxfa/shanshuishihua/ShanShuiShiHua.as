package lxfa.shanshuishihua
{
	import flash.display.Sprite;
	
	public class ShanShuiShiHua extends Sprite
	{
		private var shanShuiShiHuaSwc:ShanShuiShiHuaSwc;
		public function ShanShuiShiHua()
		{
			initShanShuiShiHuaSwc();
			initFlatWall();
		}
		private function initShanShuiShiHuaSwc():void
		{
			shanShuiShiHuaSwc=new ShanShuiShiHuaSwc();
			this.addChild(shanShuiShiHuaSwc);
		}
		private function initFlatWall():void
		{
			
		}
	}
}
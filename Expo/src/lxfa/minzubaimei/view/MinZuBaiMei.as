package lxfa.minzubaimei.view
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	
	public class MinZuBaiMei extends Sprite
	{
		private var miniCarouselReflectionView:MiniCarouselReflectionView;
		public function MinZuBaiMei()
		{
			MainSystem.getInstance().addAPI("getMinZuBaiMei",initMiniCarouselReflectionView);
		}
		private function initMiniCarouselReflectionView():MiniCarouselReflectionView
		{
			miniCarouselReflectionView=new MiniCarouselReflectionView();
			return miniCarouselReflectionView;
		}
		public function dispose():void
		{
			miniCarouselReflectionView.dispose();
			miniCarouselReflectionView=null;
		}
	}
}
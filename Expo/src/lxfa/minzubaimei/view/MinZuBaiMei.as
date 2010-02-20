package lxfa.minzubaimei.view
{
	import flash.display.Sprite;
	
	public class MinZuBaiMei extends Sprite
	{
		private var miniCarouselReflectionView:MiniCarouselReflectionView;
		public function MinZuBaiMei()
		{
			initMiniCarouselReflectionView();
		}
		private function initMiniCarouselReflectionView():void
		{
			miniCarouselReflectionView=new MiniCarouselReflectionView();
			this.addChild(miniCarouselReflectionView);
		}
		public function dispose():void
		{
			miniCarouselReflectionView.dispose();
			miniCarouselReflectionView=null;
		}
	}
}
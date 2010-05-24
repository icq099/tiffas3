package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Strong;
	
	import yzhkof.effect.MyEffect;
	import yzhkof.ui.TileContainer;
	import yzhkof.util.ObjectEvent;
	
	public class TileView extends TileContainer
	{
		private const WIDTH:Number=500;
		private const HEIGHT:Number=400;
		
		private var data:Vector.<PhotoData>;
		private var click_map:Dictionary;
		public function TileView()
		{
			super();
			initView();
		}
		private function initView():void
		{
			width=WIDTH;
			height=HEIGHT;
		}
		public function view(data:Vector.<PhotoData>):void
		{
			this.data=data;
			removeAllChildren();
			refresh();
		}
		private function refresh():void
		{
			var image_arr:Array=new Array;
			click_map=new Dictionary();
			for each(var i:PhotoData in data)
			{
				var image:ImageSmallViewer=getImageViewer(i.smallUrl);				
				appendItem(image);
				click_map[image]=i;
				image_arr.push(image);
			}
			updataChildPosition();
			var j:int;
			for(j=0;j<image_arr.length;j++)
			{
				TweenLite.from(image_arr[j],0.3,{alpha:0,x:width/2-50,y:height/2-20});
			}
		}
		private function getImageViewer(url:String):ImageSmallViewer
		{
			var image:ImageSmallViewer=new ImageSmallViewer(url);
//			TweenMax.to(image, 0, {colorMatrixFilter:{colorize:0xffffff, amount:0.5, brightness:1}});
//			image.alpha = 0.7
			image.buttonMode=true;
			image.addEventListener(MouseEvent.CLICK,__imageClick);
//			image.addEventListener(MouseEvent.ROLL_OVER,__imageOver);
//			image.addEventListener(MouseEvent.ROLL_OUT,__imageOut);
			return image;
		}
//		private function __imageOver(e:Event):void
//		{
//			TweenMax.to(e.currentTarget, 0.5, {alpha:1,colorMatrixFilter:{colorize:0xffffff, amount:0, brightness:1},ease:Strong.easeInOut});
//		}
//		private function __imageOut(e:Event):void
//		{
//			TweenMax.to(e.currentTarget, 5, {alpha:0.7,colorMatrixFilter:{colorize:0xffffff, amount:0.5, brightness:1},ease:Strong.easeOut});
//		}
		private function __imageClick(e:Event):void
		{
			dispatchEvent(new ObjectEvent("image_click",false,false,click_map[e.currentTarget]));
		}
	}
}
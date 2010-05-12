package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	
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
				addChild(image);
				click_map[image]=i;
				image_arr.push(image);
			}
			updataChildPosition();
			var j:int;
			for(j=0;j<image_arr.length;j++)
			{
				TweenLite.from(image_arr[j],0.3,{alpha:0,x:"-20",scaleX:0.9,scaleY:0.9,delay:j/10});
			}
		}
		private function getImageViewer(url:String):ImageSmallViewer
		{
			var image:ImageSmallViewer=new ImageSmallViewer(url);
			image.buttonMode=true;
			image.addEventListener(MouseEvent.CLICK,__imageClick);
			return image;
		}
		private function __imageClick(e:Event):void
		{
			dispatchEvent(new ObjectEvent("image_click",false,false,click_map[e.currentTarget]));
		}
	}
}
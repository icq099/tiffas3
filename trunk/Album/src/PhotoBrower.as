package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import yzhkof.AddToStageSetter;
	import yzhkof.util.ObjectEvent;
	
	public class PhotoBrower extends Sprite
	{		
		private var imageContainer:TileView;
		private var img_big:ImageBigViewer;
		
		private var left:Arrow=new Arrow();
		private var right:Arrow=new Arrow();
		private var currentPage:uint=0;
		
		public function PhotoBrower()
		{
			super();
			init();
		}
		private function gotoPage(page:uint):void{
			if(page>=0&&page<Mxml.Instance.pageCount)
			{
				imageContainer.view(Mxml.Instance.getPhotoData(page));
				currentPage=page;
			}
		}
		
		private function init():void
		{
			left.buttonMode=true;
			right.buttonMode=true;
			left.scaleX=-1;
			
			left.x=50;
			left.y=200;
			right.x=570;
			right.y=200;
			
			addChild(left);
			addChild(right);
			
			TweenLite.from(left,0.5,{alpha:0,x:"-20",scaleX:-1.2,scaleY:1.2,delay:1.5});
			TweenLite.from(right,0.5,{alpha:0,x:"20",scaleX:1.2,scaleY:1.2,delay:1.5});
			
			imageContainer=new TileView();
			addChild(imageContainer);
			
			imageContainer.view(Mxml.Instance.getPhotoData(0));
			
			AddToStageSetter.setObjToMiddleOfStage(imageContainer);
			AddToStageSetter.delayExcuteAfterAddToStage(imageContainer,function():void{imageContainer.y-=25;})
			
			left.addEventListener(MouseEvent.CLICK,__leftClick);
			right.addEventListener(MouseEvent.CLICK,__rightClick);
			
			imageContainer.addEventListener("image_click",__imageClick);
		}
		private function __leftClick(e:Event):void
		{
			gotoPage(currentPage-1);
		}
		private function __rightClick(e:Event):void
		{
			gotoPage(currentPage+1);	
		}
		private function __imageClick(e:ObjectEvent):void
		{
			if(!img_big)
			{
				var data:PhotoData=PhotoData(e.obj);
				img_big=new ImageBigViewer(data);
				img_big.buttonMode=true;
				addChild(img_big);
				AddToStageSetter.setObjToMiddleOfStage(img_big);
				img_big.addEventListener(MouseEvent.CLICK,__bigClick);
			}
		}
		private function __bigClick(e:Event):void
		{
			img_big.removeFromDisplayList();
			img_big=null;
		}
	}
}
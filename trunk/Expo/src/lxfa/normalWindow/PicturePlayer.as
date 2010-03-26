package lxfa.normalWindow
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import lxfa.view.tool.ToolTip;
	
	import yzhkof.loader.CompatibleLoader;
	
	public class PicturePlayer extends Sprite
	{
		private var picturePlayerUISwc:PicturePlayerUISwc;
		private var pictureUrls:Array;
		private const defaultAplha:Number=0.4;
		private const speed:Number=1;
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		private var loader:Loader;
		private var pictureContainer:Sprite;//图片的容器，倒时候可以用来移动所有的预览图
		private var pictureNum:int;//图片的总数
		private var offset:int=0;  //当前图片载入的数目
		private const defaultDistance:int=200;//两张图片在X坐标上的距离
		private const defaultScale:Number=0.15;//预览图的默认宽度
		private var previewPictureArray:Array;//存储所有的图片
		private var rubbishArray:Array;
		public function PicturePlayer(pictureUrls:Array)
		{
			initRubbishArray();
			init(pictureUrls);
			initPicturePlayerUISwc();
			initPictureContainer();
			initPictureLoader();
		}
		private function initRubbishArray():void
		{
			rubbishArray=new Array();
		}
		private function init(pictureUrls:Array):void
		{
			this.pictureUrls=pictureUrls;
			rubbishArray.push(pictureUrls);//存起来，好回收
			this.alpha=defaultAplha;
			if(pictureUrls==null)
			{
				this.pictureNum=0;
			}
			else
			{
				this.pictureNum=pictureUrls.length;
			}
			this.previewPictureArray=new Array();
			rubbishArray.push(previewPictureArray);//存起来，好回收
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		private function initPictureContainer():void
		{
			pictureContainer=new Sprite();
			rubbishArray.push(pictureContainer);//存起来，好回收
			pictureContainer.y=4;
			pictureContainer.x=4;
			picturePlayerUISwc.picturePreview.addChild(pictureContainer);
		}
		private function initPictureLoader():void
		{
			if(offset<pictureNum)
			{
				urlRequest=new URLRequest(pictureUrls[offset]);
				urlLoader=new URLLoader();
				urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
				urlLoader.load(urlRequest);
				urlLoader.addEventListener(Event.COMPLETE,onComplete);
				loader=new Loader();
			}
			else
			{
				if(urlLoader!=null)
				{
					urlLoader.close();
					urlRequest=null;
					urlLoader=null;
				}
			}
		}
		private function onComplete(e:Event):void
		{
			loader.loadBytes(urlLoader.data);
			loader.scaleX=defaultScale;
			loader.scaleY=defaultScale;
			loader.x=offset*defaultDistance;
			pictureContainer.addChild(loader);
			previewPictureArray.push(loader);
			rubbishArray.push(loader);//存起来，好回收
			offset++;//数目+1
			loader.addEventListener(MouseEvent.MOUSE_DOWN,onPreviewPictureDown);
			initPictureLoader();
		}
		private var currentPicture:Bitmap;
		private function onPreviewPictureDown(e:MouseEvent):void
		{
			if(currentPicture!=null)
			{
				Panel3(this.parent).previewPictureContainer.removeChild(currentPicture);
				currentPicture=null;
			}
			var bitmap:Bitmap=Loader(e.currentTarget).content as Bitmap;
			currentPicture=new Bitmap(bitmap.bitmapData);
			currentPicture.width=382;
			currentPicture.height=287;
			Panel3(this.parent).previewPictureContainer.addChild(currentPicture);
		}
		private function onMouseOut(e:MouseEvent):void
		{
			Tweener.addTween(this,{alpha:defaultAplha,time:speed});
		}
		private function onMouseOver(e:MouseEvent):void
		{
			Tweener.addTween(this,{alpha:1,time:speed});
		}
		private function initPicturePlayerUISwc():void
		{
			picturePlayerUISwc=new PicturePlayerUISwc();
			this.addChild(picturePlayerUISwc);
			ToolTip.init(picturePlayerUISwc);
			ToolTip.register(picturePlayerUISwc.left,"左移");
			ToolTip.register(picturePlayerUISwc.right,"右移");
			picturePlayerUISwc.left.addEventListener(MouseEvent.CLICK,onLeftClick);
			picturePlayerUISwc.right.addEventListener(MouseEvent.CLICK,onRightClick);
		}
		private var locationx:int;
		private function onLeftClick(e:MouseEvent):void
		{
			locationx=pictureContainer.x+defaultDistance;
			onClick();
		}
		private function onRightClick(e:MouseEvent):void
		{
			if(locationx!=0)
			{
				locationx=pictureContainer.x-defaultDistance;
				onClick();
			}
		}
		private function onClick():void
		{
			picturePlayerUISwc.left.mouseEnabled=picturePlayerUISwc.right.mouseEnabled=false;
			Tweener.addTween(pictureContainer,{x:locationx,time:2,onComplete:function():void{
			   picturePlayerUISwc.left.mouseEnabled=picturePlayerUISwc.right.mouseEnabled=true;
			}});
		}
		public function close():void
		{
			var i:int;
			for(i=0;i<rubbishArray.length;i++)
			{
				rubbishArray[i]=null;
			}
		}
	}
}
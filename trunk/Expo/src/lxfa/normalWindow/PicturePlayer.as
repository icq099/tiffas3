package lxfa.normalWindow
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.tool.ToolTip;
	
	public class PicturePlayer extends Sprite
	{
		private var picturePlayerUISwc:PicturePlayerUISwc;
		private var pictureUrls:Array;
		private const defaultAplha:Number=0.4;
		private const speed:Number=1;
		private var urlRequest:URLRequest;
		private var loader:Loader=new Loader;
		private var pictureContainer:Sprite;//图片的容器，倒时候可以用来移动所有的预览图
		private var pictureNum:int;//图片的总数
		private var offset:int=0;  //当前图片载入的数目
		private const defaultDistance:int=60;//两张图片在X坐标上的距离
		private const defaultScale:Number=0.15;//预览图的默认宽度
		private var previewPictureArray:Array;//存储所有的图片
		private var pictureSelfContainer:Array;//没张图片都有sprite来装，并模拟图片点击时间。这个数组就存储所有的图片sprite
		private var rubbishArray:Array;
		private var defaultWidth:int=50;
		private var defaultHeight:int=50;
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
			pictureSelfContainer=new Array();
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
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				loader.load(urlRequest);
			}
		}
		private function onComplete(e:Event):void
		{
			var bitmap:Bitmap=Bitmap(loader.content);
			bitmap.width=defaultWidth;
			bitmap.height=defaultHeight;
			bitmap.x=offset*defaultDistance;
			var sprite:Sprite=new Sprite();
			sprite.name=String(offset);
			sprite.addChild(bitmap);
			pictureContainer.addChild(sprite);
			previewPictureArray.push(bitmap);
			rubbishArray.push(sprite);//存起来，好回收
			pictureSelfContainer.push(sprite);
			rubbishArray.push(pictureSelfContainer);
			offset++;//数目+1
			sprite.addEventListener(MouseEvent.CLICK,onPreviewPictureDown);
			MemoryRecovery.getInstance().gcFun(loader.contentLoaderInfo,Event.COMPLETE,onComplete);
			initPictureLoader();
		}
		private var currentPicture:Bitmap;
		private function onPreviewPictureDown(e:MouseEvent):void
		{
			if(currentPicture!=null)//删除当前的图片
			{
				Panel3(this.parent).previewPictureContainer.removeChild(currentPicture);
				currentPicture=null;
			}
			var bitmap:Bitmap=previewPictureArray[int(e.currentTarget.name)];
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
			if(pictureContainer.x+defaultDistance*5<defaultDistance*5)
			{
				locationx=pictureContainer.x+defaultDistance*5;
				onClick();
			}
		}
		private function onRightClick(e:MouseEvent):void
		{
			if(pictureContainer.width+pictureContainer.x>defaultDistance*5)
			{
				locationx=pictureContainer.x-defaultDistance*5;
				onClick();
			}
		}
		private function onClick():void
		{
			picturePlayerUISwc.left.mouseEnabled=picturePlayerUISwc.right.mouseEnabled=false;
			Tweener.addTween(pictureContainer,{x:locationx,time:1,onComplete:function():void{
			   picturePlayerUISwc.left.mouseEnabled=picturePlayerUISwc.right.mouseEnabled=true;
			}});
		}
		public function close():void
		{
			MemoryRecovery.getInstance().gcFun(loader,Event.COMPLETE,onComplete);
			MemoryRecovery.getInstance().gcObj(loader);
			for each (var b:Bitmap in previewPictureArray)
			{
				MemoryRecovery.getInstance().gcObj(b);
			}
			for each(var sprite:Sprite in pictureSelfContainer)
			{
				MemoryRecovery.getInstance().gcFun(sprite,MouseEvent.CLICK,onPreviewPictureDown);
				MemoryRecovery.getInstance().gcObj(sprite);
			}
			MemoryRecovery.getInstance().gcFun(this,MouseEvent.MOUSE_OUT,onMouseOut);
			MemoryRecovery.getInstance().gcFun(this,MouseEvent.MOUSE_OVER,onMouseOver);
			MemoryRecovery.getInstance().gcFun(picturePlayerUISwc.left,MouseEvent.CLICK,onLeftClick);
			MemoryRecovery.getInstance().gcFun(picturePlayerUISwc.right,MouseEvent.CLICK,onRightClick);
			MemoryRecovery.getInstance().gcObj(picturePlayerUISwc.left);
			MemoryRecovery.getInstance().gcObj(picturePlayerUISwc.right);
			MemoryRecovery.getInstance().gcObj(picturePlayerUISwc);
			var i:int;
			for(i=0;i<rubbishArray.length;i++)
			{
				rubbishArray[i]=null;
			}
		}
	}
}
package view.player
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	
	import view.ToolTip;
	
	public class PicturePlayer extends Sprite
	{
		private var picturePlayerUISwc:PicturePlayerUISwc;   //图片播放器的界面
		private var pictureUrls:Array;                       //图片数组
		private const defaultAplha:Number=0.4;               //默认透明度
		private const speed:Number=1;                        //图片移动的时间间隔
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
		private var pictureViewer:Sprite;
		public function PicturePlayer(pictureUrls:Array,pictureViewer:Sprite)
		{
			this.pictureViewer=pictureViewer;
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
			}else//全部图片加载完毕
			{
				if(pictureUrls.length<5)
				{
					if(picturePlayerUISwc!=null)
					{
						picturePlayerUISwc.left.visible=false;
						picturePlayerUISwc.right.visible=false;
					}
				}
			}
		}
		private function onComplete(e:Event):void
		{
			var bitmap:Bitmap=Bitmap(loader.content);
			bitmap.width=defaultWidth;
			bitmap.height=defaultHeight;
			bitmap.x=offset*defaultDistance;               //图片位置
			var sprite:Sprite=new Sprite();
			sprite.name=String(offset);
			sprite.addChild(bitmap);
			pictureContainer.addChild(sprite);
			previewPictureArray.push(bitmap);
			rubbishArray.push(sprite);                    //存起来，好回收
			pictureSelfContainer.push(sprite);
			rubbishArray.push(pictureSelfContainer);
			offset++;                                     //数目+1
			sprite.addEventListener(MouseEvent.CLICK,onPreviewPictureDown);
			MemoryRecovery.getInstance().gcFun(loader.contentLoaderInfo,Event.COMPLETE,onComplete);
			initPictureLoader();                          //继续读取图片
			if(offset==1)                                 //显示第一张图片
			{
				sprite.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		private var currentPicture:Bitmap;
		private function onPreviewPictureDown(e:MouseEvent):void
		{
			if(currentPicture!=null)//删除当前的图片
			{
				pictureViewer.removeChild(currentPicture);
				currentPicture=null;
			}
			var bitmap:Bitmap=previewPictureArray[int(e.currentTarget.name)];
			currentPicture=new Bitmap(bitmap.bitmapData);
			currentPicture.width=382;
			currentPicture.height=287;
			pictureViewer.addChild(currentPicture);
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
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(loader,Event.COMPLETE,onComplete);
			if(loader!=null)
			{
				if(loader.parent!=null)
				{
					loader.parent.removeChild(loader);
				}
				try
				{
					loader.close();
					loader.unload();
				}catch(e:Error)
				{
					
				}
				loader=null;
			}
			for each (var b:Bitmap in previewPictureArray)
			{
				if(b!=null)
				{
					if(b.bitmapData!=null)
					{
						b.bitmapData.dispose();
					}
					if(b.parent!=null)
					{
						b.parent.removeChild(b);
					}
					b=null;
				}
			}
			for each(var sprite:Sprite in pictureSelfContainer)
			{
				MemoryRecovery.getInstance().gcFun(sprite,MouseEvent.CLICK,onPreviewPictureDown);
				if(sprite!=null)
				{
					if(sprite.parent!=null)
					{
						sprite.parent.removeChild(sprite);
					}
					sprite=null;
				}
			}
			MemoryRecovery.getInstance().gcFun(this,MouseEvent.MOUSE_OUT,onMouseOut);
			MemoryRecovery.getInstance().gcFun(this,MouseEvent.MOUSE_OVER,onMouseOver);
			MemoryRecovery.getInstance().gcFun(picturePlayerUISwc.left,MouseEvent.CLICK,onLeftClick);
			MemoryRecovery.getInstance().gcFun(picturePlayerUISwc.right,MouseEvent.CLICK,onRightClick);
			if(picturePlayerUISwc.left!=null)
			{
				if(picturePlayerUISwc.left.parent!=null)
				{
					picturePlayerUISwc.left.parent.removeChild(picturePlayerUISwc.left);
				}
				picturePlayerUISwc.left=null;
			}
			if(picturePlayerUISwc.right!=null)
			{
				if(picturePlayerUISwc.right.parent!=null)
				{
					picturePlayerUISwc.right.parent.removeChild(picturePlayerUISwc.right);
				}
				picturePlayerUISwc.right=null;
			}
			if(picturePlayerUISwc!=null)
			{
				if(picturePlayerUISwc.parent!=null)
				{
					picturePlayerUISwc.parent.removeChild(picturePlayerUISwc);
				}
				picturePlayerUISwc=null;
			}
			var i:int;
			for(i=0;i<rubbishArray.length;i++)
			{
				rubbishArray[i]=null;
			}
		}
	}
}
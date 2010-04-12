package plugins.lxfa.yangmengbagui.view{	
	import core.manager.MainSystem;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	
	import plugins.model.ItemModel;
	public class MiniCarouselReflectionView extends Sprite{
		private var basicView		:BasicView;
		//反射ReflectionView物件。
		private var rootNode	:DisplayObject3D;
		//DisplayObject3D物件，可以想像是PV3D裡的空白MovieClip。
		//本身是個容器,可以透過addChild加入任何繼承DisplayObject3D的物件。
		private var radius		:Number = 1000;//半徑
		private var angleUnit	:Number ;
		//360徑度 = Math.PI * 2 弧度
		//除以數量即可得到單位弧度。
		private var currentIndex:Number = 0;//目前的索引值
		private var ldr			:Loader;	//載入大圖用的Loader。
		private var itemOfNumber:int;
		private var yangMengBaGuiModel:ItemModel;
		private var rubbishArray:Array=new Array();//垃圾回收的数组
		private var pictureUrls:Array;
		private var videoUrls:Array;
		private const ID:int=56;
		private const min:int=44;
		public function MiniCarouselReflectionView(){
			initMinZuBaiMeiModel();//读取数据库
		}

		private function initMinZuBaiMeiModel():void
		{
			yangMengBaGuiModel=new ItemModel("NormalWindow");
			onModelComplete();
		}
		private function onModelComplete():void
		{
			pictureUrls=yangMengBaGuiModel.getPictureUrls(ID);//读取图片的数目,正常是12个
			videoUrls=yangMengBaGuiModel.getVideoUrls(ID);
			angleUnit = (Math.PI ) / pictureUrls.length;//角度的偏移量
			init3DEngine();
			init3DObject();
		}
		private function init3DEngine():void{
			this.x=0;
			this.y=150;
			basicView = new BasicView(900, 600, false, true, "Target");			
			//設定反射面的 y 軸方向高度
			basicView.camera.y = 0;
			basicView.camera.z = -3000;
			basicView.camera.focus=140;
			basicView.viewport.buttonMode = true;
			//PV3D物件預設都不會有滑鼠指標手示，
			//BasicBiew是繼承Sprite，
			//所以可以開啟buttonMode屬性。
			this.addChild(basicView);
			basicView.y=-250;
			basicView.x=-26;
			this.addEventListener(Event.ADDED_TO_STAGE,added);
		}
		private function added(e:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
			this.removeEventListener(Event.ADDED_TO_STAGE,added);
		}
		private function init3DObject():void{
			rootNode = new DisplayObject3D();
			var imgUrl:String;
			var videoUrl:String;
			var planeHeight:int=-1;
			for (var i:int = 0; i < pictureUrls.length; i++) {	
				imgUrl=pictureUrls[i];			
				createPlane(imgUrl,i);
			}
			for(var j:int=0;j<videoUrls.length;j++)
			{
				videoUrl=videoUrls[j];
				createPlane(videoUrl,j,"movie");
			}
			rootNode.rotationY=-25;
			basicView.scene.addChild(rootNode);
		}
		private function createPlane(imgUrl:String,i:int,type:String="picture"):void
		{
			var bmpMat		:MaterialObject3D;
			var loader:Loader=new Loader();
			loader.load(new URLRequest(imgUrl));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function loaded(e:Event):void{
				if(rubbishArray!=null)
				{
					var _radian	:Number = i * angleUnit*0.8;
					if(type=="picture")
					{
						bmpMat=new BitmapMaterial(Bitmap(loader.content).bitmapData);
					}else
					{
						bmpMat=new MovieMaterial(loader.content);
					}
					bmpMat.interactive = true;
					bmpMat.smooth = true;	
					var plane:Plane=new Plane(new ColorMaterial(0xffffff, 0), 320, 240, 4, 4);
				    plane.material=bmpMat;
				    plane.name=String(min+i);
					plane.x =Math.cos(_radian) * radius;
					plane.z =Math.sin(_radian) * radius;
					plane.rotationY = 270 - (_radian * 180 / Math.PI)+180;
					//修正反射Plane物件的y軸。				
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver,false,0,true);
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut,false,0,true);
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, on3DPress,false,0,true);
					rootNode.addChild(plane);
					rubbishArray.push(plane);
				}
			});
		}
		private function onStageClick(e:MouseEvent):void{
			ldr.unload();
			//移除Loader載入的物件。
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			//取消偵聽。
		}
		private function on3DOver(e:InteractiveScene3DEvent):void {			
			//當滑鼠進入感應區時，修改廣播者scale屬性，放大1.2倍。
			e.displayObject3D.scale = 1.2;			
		}
		private function on3DOut(e:InteractiveScene3DEvent):void {
			//當滑鼠離開感應區時，回復原本的大小。
			e.displayObject3D.scale = 1;			
		}
		private function on3DPress(e:InteractiveScene3DEvent):void{
			MainSystem.getInstance().runAPIDirectDirectly("showNormalWindow",[int(Plane(e.currentTarget).name)]);
		}
		private function onEventRender3D(e:Event):void {	
			if(basicView!=null)
			{
				basicView.singleRender();
			}		
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(yangMengBaGuiModel,Event.COMPLETE,onModelComplete);
			MemoryRecovery.getInstance().gcObj(yangMengBaGuiModel,true);
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,onEventRender3D);
			if(basicView.renderer!=null)
			{
				basicView.renderer.destroy();
			}
			for each(var plane:Plane in rubbishArray)
			{
				if(plane.material!=null)
				{
					if(plane.material.bitmap!=null)
					{
						plane.material.bitmap.dispose();
					}
					plane.material.destroy();
				}
				if(plane.parent!=null)
				{
					rootNode.removeChild(plane);
				}
				plane.removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				plane.removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				plane.removeEventListener(InteractiveScene3DEvent.OBJECT_PRESS, on3DPress);
				plane=null;
			}
			rubbishArray=null;
			basicView.scene.removeChild(rootNode);
			rootNode=null;
		}
	}
}

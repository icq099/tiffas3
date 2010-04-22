package plugins.lxfa.yangmengbagui.view{	
	import core.manager.MainSystem;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	import memory.MyGC;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	
	import plugins.model.ItemModel;
	public class MiniCarouselReflectionView extends Sprite{
		private var basicView		:BasicView;
		//反射ReflectionView物件。
		//DisplayObject3D物件，可以想像是PV3D裡的空白MovieClip。
		//本身是個容器,可以透過addChild加入任何繼承DisplayObject3D的物件。
		private var radius		:Number = 1000;//半徑
		private var angleUnit	:Number ;
		//360徑度 = Math.PI * 2 弧度
		//除以數量即可得到單位弧度。
		private var currentIndex:Number = 0;//目前的索引值
		private var itemOfNumber:int;
		private var yangMengBaGuiModel:ItemModel;
		private var rubbishArray:Array=new Array();//垃圾回收的数组
		private var pictureUrls:Array;
		private var videoUrls:Array;
		private const ID:int=56;
		private const min:int=44;
		private const defaultRotationY:Number=15;
		private const maxRotationY:Number=20;
		private const minRotationY:Number=10;
		public function MiniCarouselReflectionView(){
			initModel();//读取数据库
		}
		private function initModel():void
		{
			yangMengBaGuiModel=new ItemModel();
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
			basicView = new BasicView(900, 600, false, true, FreeCamera3D.TYPE);			
			//設定反射面的 y 軸方向高度
			basicView.camera.y = 0;
			basicView.camera.z = -800;
			basicView.camera.focus=280;
			basicView.camera.rotationY=defaultRotationY;
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
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D,false,0,true);
			this.removeEventListener(Event.ADDED_TO_STAGE,added);
		}
		private function init3DObject():void{
			var imgUrl:String;
			var videoUrl:String;
			var planeHeight:int=-1;
			for (var i:int = 0; i < pictureUrls.length; i++) {	
				imgUrl=pictureUrls[i];			
				createPlane(imgUrl,i);
			}
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
					bmpMat=new BitmapMaterial(Bitmap(loader.content).bitmapData);
					bmpMat.interactive = true;
					bmpMat.smooth = true;	
					var plane:Plane=new Plane(new ColorMaterial(0xffffff, 0), 320, 240, 4, 4);
				    plane.material=bmpMat;
				    plane.name=String(min+i);
					plane.x =Math.cos(_radian) * radius;
					plane.z =Math.sin(_radian) * radius;
					plane.rotationY = 270 - (_radian * 180 / Math.PI)+180;
					rubbishArray.push(plane);
					//修正反射Plane物件的y軸。				
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver,false,0,true);
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut,false,0,true);
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, on3DPress,false,0,true);
					basicView.scene.addChild(plane);
				}
			});
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
			refreshCameraRotation();
		}
		private function refreshCameraRotation():void
		{
			if(basicView!=null)
			{
				basicView.camera.rotationY=(mouseX/900)*(maxRotationY-minRotationY)+minRotationY;
			}
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,onEventRender3D);
			MemoryRecovery.getInstance().gcFun(this,Event.ADDED_TO_STAGE,added);
			if(yangMengBaGuiModel!=null)
			{
				yangMengBaGuiModel.dispose();
				yangMengBaGuiModel=null;
			}
			for each(var plane:Plane in rubbishArray)
			{
				MemoryRecovery.getInstance().gcFun(plane,InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				MemoryRecovery.getInstance().gcFun(plane,InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				MemoryRecovery.getInstance().gcFun(plane,InteractiveScene3DEvent.OBJECT_PRESS, on3DPress);
				if(plane.parent!=null)
				{
					plane.parent.removeChild(plane);
				}
				if(plane.material!=null)
				{
					if(plane.material.bitmap!=null)
					{
						plane.material.bitmap.dispose();
					}
					plane.material.destroy();
				}
				plane=null;
			}
			pictureUrls=null;
			videoUrls=null;
			rubbishArray=null;
			if(basicView!=null)
			{
        		if(basicView.parent!=null)
        		{
        			basicView.parent.removeChild(basicView);
        		}
				basicView.camera.rotationY=195;
	        	basicView.renderer.destroy();
	        	basicView.renderer=null;
	        	basicView.scene=null;
	        	basicView.viewport.destroy();
	        	basicView.viewport=null;
        		basicView=null;
			}
			MyGC.gc();
		}
	}
}

package lxfa.minzubaimei.view {	
	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.URLRequest;
	
	import lsd.CustomWindow.CustomWindow;
	
	import lxfa.model.ItemModel;
	import lxfa.utils.MemoryRecovery;
	
	import org.papervision3d.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	public class MiniCarouselReflectionView extends Sprite{
		private var basicView		:BasicView;
		//反射ReflectionView物件。
		private var rootNode	:DisplayObject3D;
		//DisplayObject3D物件，可以想像是PV3D裡的空白MovieClip。
		//本身是個容器,可以透過addChild加入任何繼承DisplayObject3D的物件。
		private var radius		:Number = 650;//半徑
		private var angleUnit	:Number ;
		//360徑度 = Math.PI * 2 弧度
		//除以數量即可得到單位弧度。
		private var currentIndex:Number = 0;//目前的索引值
		private var ldr			:Loader;	//載入大圖用的Loader。
		private var itemOfNumber:int;
		private const min:int=27;
		private var matArray:Array=new Array();    //回收素材的数组
		private var planeArray:Array=new Array();  //回收平面的数组
		private var backGround:CustomWindow;
		private var itemModel:ItemModel;
		private const ID:int=53;
		private var pictureUrls:Array=new Array();
		private var customDown:CustomWindowUIDown;
		public function MiniCarouselReflectionView(){
			init();
		}
		private function init():void
		{
			itemModel=new ItemModel("NormalWindow");
			pictureUrls=itemModel.getPictureUrls(ID);
			angleUnit = (Math.PI * 2) / pictureUrls.length;//角度的偏移量
			init3DEngine();
			init3DObject();
			initObject();		
		}
		private function init3DEngine():void{
			basicView = new BasicView(600, 600, false, true, "Target");		
			//設定反射面的 y 軸方向高度
			basicView.camera.y = 1200;
			basicView.camera.z = -3800;
			basicView.viewport.buttonMode = true;
			//PV3D物件預設都不會有滑鼠指標手示，
			//BasicBiew是繼承Sprite，
			//所以可以開啟buttonMode屬性。
			this.addChild(basicView);
			initCustomDown();
			basicView.y=-250;
			basicView.x=-26;
			this.addEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removed);
		}
		private function on_added_to_stage(e:Event):void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ADDED_TO_STAGE,on_added_to_stage);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
		}
		private function removed(e:Event):void
		{
			basicView.viewport.destroy();
//			basicView.viewport=null;
//			basicView=null;
			MemoryRecovery.getInstance().gcFun(this,Event.REMOVED_FROM_STAGE,removed);
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME,onEventRender3D);
		}
		private function initCustomDown():void
		{
			customDown=new CustomWindowUIDown();
			customDown.scaleX=customDown.scaleY=0.6;
			customDown.x=50;
			customDown.y=200;
			this.addChild(customDown);
			customDown.bar.visible=false;
			customDown.left.addEventListener(MouseEvent.CLICK,onButtonClick);
			customDown.right.addEventListener(MouseEvent.CLICK,onButtonClick);
			customDown.left.buttonMode=true;
			customDown.right.buttonMode=true;
		}
		private function init3DObject():void{
			rootNode = new DisplayObject3D();
			//建立一個DisplayObject3D物件
			basicView.scene.addChild(rootNode);
			//加入至scene。
			var imgUrl:String;
			//宣告變數, 避免在判斷式時重復宣告。
			var planeHeight:int=-1;
//			var bmpMat		:MaterialObject3D;
			for (var i:int = 0; i < pictureUrls.length; i++) {	
				imgUrl=pictureUrls[i];			
//				bmpMat = new ReflectionFileMaterial(imgUrl, true);
//				planeHeight = 400;			
//				bmpMat.doubleSided = true; //雙面模式
//				bmpMat.interactive = true;
//				bmpMat.smooth = true;		
				var _plane	:Plane = new Plane(new ColorMaterial(0xffffff, 0), 320, 400, 2, 2);
				var _radian	:Number = i * angleUnit;
//				_plane.material=bmpMat;
				_plane.x = Math.cos(_radian) * radius;
				_plane.z = Math.sin(_radian) * radius;
//				_plane.setID(min+i);
				//透過三角函數來排列。
				_plane.rotationY = 270 - (_radian * 180 / Math.PI) ;
//				_plane.useOwnContainer = true;					
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, on3DPress);
				basicView.scene.addChild(_plane);
				//偵聽
//				rootNode.addChild(_plane);
				planeArray.push(_plane);
				trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			}
		}
		private function createPlane(imgUrl:String,i:int):void
		{
			var bmpMat		:BitmapMaterial;
			var loader:Loader=new Loader();
			loader.load(new URLRequest(imgUrl));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function loaded(e:Event):void{
			    bmpMat=new BitmapMaterial(Bitmap(loader.content).bitmapData);
				bmpMat.interactive = true;
				bmpMat.smooth = true;		
				var _radian	:Number = i * angleUnit;
				var plane:Plane=new Plane(new ColorMaterial(0xffffff, 0), 320, 240, 4, 4);
			    plane.material=bmpMat;
				plane.x =Math.cos(_radian) * radius;
				plane.z = Math.sin(_radian) * radius;
//				rubbishArray.push(plane);
				//修正反射Plane物件的y軸。				
//				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onEvent3DOver);
//				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onEvent3DOut);
//				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onEvent3DClick);
				basicView.scene.addChild(plane);
			});
		}
		private function initObject():void{
			//偵聽MouseEvent.MOUSE_WHEEL事件。
		}
		private function onStageMouseWheel(e:MouseEvent):void {
			//MouseEvent類別, delta屬性可以得到滑鼠滾輪的值
			//e.dalta如果大於0,表示滾輪向上,小於0表示向下。	
			if (e.delta >0) {
				currentIndex++;
			}else {
				currentIndex--;
			}
			updateRootNodeTransform();
		}
		private function onStageClick(e:MouseEvent):void{
			ldr.unload();
			//移除Loader載入的物件。
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			//取消偵聽。
//			container.right_btn.visible = container.left_btn.visible = true;
			//讓左、右Button看的見。
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
			var _target:Plane=Plane(e.currentTarget);
//            currentIndex=_target.getID()-min+3;
            updateRootNodeTransform();
		}
		private function onButtonClick(e:Event):void {
			if(e.currentTarget == customDown.right){
				currentIndex++;
			}else{
				currentIndex--;
			}
			updateRootNodeTransform();
		}
		private function updateRootNodeTransform():void {
			//更新rootNode的rotationY值
			Tweener.addTween(rootNode,{
				rotationY   :currentIndex * angleUnit * 180 / Math.PI,
				//目前的currentIndex值，乘上單位弧度
				//rotation用的單位是徑度,所以要將弧度轉換成徑度。				
				time		:0.5
			} );
		}
		private function onEventRender3D(e:Event):void {			
			basicView.singleRender();
			//運算。
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(customDown.left,MouseEvent.CLICK,onButtonClick);
			MemoryRecovery.getInstance().gcFun(customDown.right,MouseEvent.CLICK,onButtonClick);
			MemoryRecovery.getInstance().gcObj(customDown.left);
			MemoryRecovery.getInstance().gcObj(customDown.right);
			MemoryRecovery.getInstance().gcObj(customDown);
			for each(var plane:Plane in planeArray)
			{
				MemoryRecovery.getInstance().gcFun(plane,InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				MemoryRecovery.getInstance().gcFun(plane,InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				MemoryRecovery.getInstance().gcFun(plane,InteractiveScene3DEvent.OBJECT_PRESS, on3DPress);
				basicView.scene.removeChild(plane);
				if(plane.material!=null)
				{
					if(plane.material.bitmap!=null)
					{
						plane.material.bitmap.dispose();
						plane.material.bitmap=null;
					}
					plane.material.destroy();
				}
				plane=null;
			}
			basicView.scene.removeChild(rootNode);
			planeArray=null;
			MemoryRecovery.getInstance().gcFun(stage,MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
			basicView.renderer.destroy();
			basicView.renderer=null;
			basicView.scene=null;
        	MemoryRecovery.getInstance().gcObj(basicView);
		}
	}
}

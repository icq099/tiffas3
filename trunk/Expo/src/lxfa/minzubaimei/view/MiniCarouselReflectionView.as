package lxfa.minzubaimei.view {	
	import caurina.transitions.Tweener;
	
	import communication.MainSystem;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	
	import lxfa.minzubaimei.model.MinZuBaiMeiModel;
	import lxfa.view.pv3dAddOn.milkmidi.papervision3d.materials.ReflectionFileMaterial;
	import lxfa.view.pv3dAddOn.org.papervision3d.objects.primitives.NumberPlane;
	
	import mx.managers.PopUpManager;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	public class MiniCarouselReflectionView extends Sprite{
		private var container:MinZuBaiMeiSwc;
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
		private var minZuBaiMeiModel:MinZuBaiMeiModel;
		private var bg:ShanShuiShiHuaSwc;
		private var rubbishArray:Array=new Array();//垃圾回收的数组
		public function MiniCarouselReflectionView(){
			initBackGround();//加载背景
			initMinZuBaiMeiModel();//读取数据库
		}
		//初始化背景
		private function initBackGround():void
		{
			bg=new ShanShuiShiHuaSwc();
			this.addChild(bg);
			container=new MinZuBaiMeiSwc();
			container.x=(bg.width-container.width)/4;
			container.y=(bg.height-container.height)/2-30;
			bg.addChild(container);
			rubbishArray.push(bg);
			rubbishArray.push(container);
		}
		private function initMinZuBaiMeiModel():void
		{
			minZuBaiMeiModel=new MinZuBaiMeiModel();
			minZuBaiMeiModel.addEventListener(Event.COMPLETE,onModelComplete);
			rubbishArray.push(minZuBaiMeiModel);
		}
		private function onModelComplete(e:Event):void
		{
			itemOfNumber=minZuBaiMeiModel.getItemOfNumber();//读取图片的数目,正常是12个
			angleUnit = (Math.PI * 2) / itemOfNumber;//角度的偏移量
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
			container.addChild(basicView);
			basicView.y=-250;
			basicView.x=-26;
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
			rubbishArray.push(basicView);
		}
		private function init3DObject():void{
			rootNode = new DisplayObject3D();
			//建立一個DisplayObject3D物件
			basicView.scene.addChild(rootNode);
			//加入至scene。
			var imgUrl:String;
			//宣告變數, 避免在判斷式時重復宣告。
			var planeHeight:int=-1;
			var bmpMat		:MaterialObject3D;
			for (var i:int = 0; i < itemOfNumber; i++) {	
				imgUrl=minZuBaiMeiModel.getImgUrl(i);			
				bmpMat = new ReflectionFileMaterial(imgUrl, true);
				planeHeight = 400;			
				bmpMat.doubleSided = true; //雙面模式
				bmpMat.interactive = true;
				bmpMat.smooth = true;		
				var _plane	:NumberPlane = new NumberPlane(bmpMat, 320, 400, 2, 2);
				var _radian	:Number = i * angleUnit;
				_plane.x = Math.cos(_radian) * radius;
				_plane.z = Math.sin(_radian) * radius;
				_plane.setID(minZuBaiMeiModel.getMin()+i);
				//透過三角函數來排列。
				_plane.rotationY = 270 - (_radian * 180 / Math.PI) ;
				_plane.useOwnContainer = true;					
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, on3DPress);
				//偵聽
				rootNode.addChild(_plane);
				rubbishArray.push(bmpMat);
				rubbishArray.push(_plane);
			}
			rubbishArray.push(rootNode);
		}
		private function initObject():void{
			container.right_btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			container.left_btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			this.addEventListener(Event.ADDED_TO_STAGE,ADDED_TO_STAGE);
			//偵聽MouseEvent.MOUSE_WHEEL事件。
		}
		private function ADDED_TO_STAGE(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
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
			container.right_btn.visible = container.left_btn.visible = true;
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
			var _target:NumberPlane=NumberPlane(e.currentTarget);
			MainSystem.getInstance().runAPIDirect("showNormalWindow",[_target.getID()]);
            currentIndex=_target.getID()-minZuBaiMeiModel.getMin()+3;
            updateRootNodeTransform();
		}
		private function onButtonClick(e:Event):void {
			if(e.currentTarget == container.right_btn){
				currentIndex++;
				//如果廣播者是right_btn,就讓目前的索引值加一
				//currentIndex++也可寫成
				//currentIndex += 1或是
				//currentIndex = currentIndex+1
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
			basicView.renderer.destroy();
			basicView.viewport.destroy();
			var i:int=0;
			for(;i<rubbishArray.length;i++)
			{
				rubbishArray[i]=null;
			}
		}
	}
}

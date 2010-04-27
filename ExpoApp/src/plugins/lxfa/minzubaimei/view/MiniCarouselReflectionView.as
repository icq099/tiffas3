package plugins.lxfa.minzubaimei.view{	
	import caurina.transitions.Tweener;
	
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	
	import org.papervision3d.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	
	import plugins.model.ItemModel;
	import plugins.yzhkof.view.MapToolTip;
	
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
		private var planeArray:Array=new Array();  //回收平面的数组
		private var itemModel:ItemModel;
		private const ID:int=53;
		private var pictureUrls:Array=new Array();    //图片的路径s
		private var pictureNames:Array=new Array();   //图片的名字
		private var customDown:LeftRightUI;           //左右按钮
		private var tip_sprite:MapToolTip=new MapToolTip();
		public function MiniCarouselReflectionView(){
			init();
		}
		private function init():void
		{
			itemModel=new ItemModel();
			pictureUrls=itemModel.getPictureUrls(ID);
			pictureNames=itemModel.getPictureNames(ID);
			angleUnit = (Math.PI * 2) / pictureUrls.length;//角度的偏移量
			init3DEngine();
			init3DObject();
		}
		private function init3DEngine():void{
			basicView = new BasicView(600, 600, false, true, "Target");		
			//設定反射面的 y 軸方向高度
			basicView.camera.y = 600;
			basicView.camera.z = -3200;
			basicView.viewport.buttonMode = true;
			//PV3D物件預設都不會有滑鼠指標手示，
			//BasicBiew是繼承Sprite，
			//所以可以開啟buttonMode屬性。
			this.addChild(basicView);
			initCustomDown();
			basicView.y=-250;
			basicView.x=-26;
			this.addEventListener(Event.ADDED_TO_STAGE,on_added_to_stage);
		}
		private function on_added_to_stage(e:Event):void
		{
			MemoryRecovery.getInstance().gcFun(this,Event.ADDED_TO_STAGE,on_added_to_stage);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel,false,0,true);
		}
		private function initCustomDown():void
		{
			customDown=new LeftRightUI();
			customDown.y=30;
			customDown.x=-30;
			this.addChild(customDown);
			customDown.left.addEventListener(MouseEvent.CLICK,onButtonClick,false,0,true);
			customDown.right.addEventListener(MouseEvent.CLICK,onButtonClick,false,0,true);
		}
		private function init3DObject():void{
			rootNode = new DisplayObject3D();
			basicView.scene.addChild(rootNode);
			var imgUrl:String;
			var planeHeight:int=-1;
			for (var i:int = 0; i < pictureUrls.length; i++) {	
				imgUrl=pictureUrls[i];			
				createPlane(imgUrl,i);
			}
			customDown.right.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			customDown.right.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
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
				bmpMat.doubleSided=true;
				var _radian	:Number = i * angleUnit;
				var plane:Plane=new Plane(new ColorMaterial(0xffffff, 0), 320, 240, 4, 4);
			    plane.material=bmpMat;
				plane.x =Math.cos(_radian) * radius;
				plane.z = Math.sin(_radian) * radius;
				plane.rotationY = 270 - (_radian * 180 / Math.PI) ;
				planeArray.push(plane);
				plane.name=i.toString();
				plane.tip=pictureNames[i];
				//修正反射Plane物件的y軸。				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, on3DPress);
				rootNode.addChild(plane);
			});
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
		private function on3DOver(e:InteractiveScene3DEvent):void {			
			//當滑鼠進入感應區時，修改廣播者scale屬性，放大1.2倍。
			e.displayObject3D.scale = 1.2;		
			tip_sprite.text=e.currentTarget.tip;
			this.addChild(tip_sprite);		
		}
		private function on3DOut(e:InteractiveScene3DEvent):void {
			//當滑鼠離開感應區時，回復原本的大小。
			e.displayObject3D.scale = 1;		
			this.removeChild(tip_sprite);	
		}
		private function on3DPress(e:InteractiveScene3DEvent):void{
			var _target:Plane=Plane(e.currentTarget);
			var id:int=int(_target.name);
			if(currentIndex==id+3)//所点击的图片是不是在最前面啊
			{
				ScriptManager.getInstance().runScriptByName(ScriptName.SHOW_NORMAL_WINDOW,[id+min]);
			}else//不然就旋转图片
			{
	            currentIndex=id+3;
	            updateRootNodeTransform();
			}
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
			refreshTipLocation();//更新tooltip的位置
		}
		private function refreshTipLocation():void
		{
			if(tip_sprite!=null)
			{
				tip_sprite.x=mouseX;
				tip_sprite.y=mouseY;
			}
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(customDown.left,MouseEvent.CLICK,onButtonClick);
			MemoryRecovery.getInstance().gcFun(customDown.right,MouseEvent.CLICK,onButtonClick);
			MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME, onEventRender3D);
			MemoryRecovery.getInstance().gcFun(stage,MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
			if(itemModel!=null)
			{
				itemModel.dispose();
				itemModel=null;
			}
			if(tip_sprite!=null)
			{
				if(tip_sprite.parent!=null)
				{
					tip_sprite.parent.removeChild(tip_sprite);
				}
				tip_sprite=null;
			}
			if(customDown.left!=null)
			{
				if(customDown.left.parent!=null)
				{
					customDown.left.parent.removeChild(customDown.left);
				}
				customDown.left=null;
			}
			if(customDown.right!=null)
			{
				if(customDown.right.parent!=null)
				{
					customDown.right.parent.removeChild(customDown.right);
				}
				customDown.right=null;
			}
			if(customDown!=null)
			{
				if(customDown.parent!=null)
				{
					customDown.parent.removeChild(customDown);
				}
				customDown=null;
			}
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
			if(rootNode!=null)
			{
				if(rootNode.parent!=null)
				{
					rootNode.parent.removeChild(rootNode);
				}
				rootNode=null;
			}
			planeArray=null;
			MemoryRecovery.getInstance().gcFun(stage,MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
			pictureUrls=null;
			pictureNames=null;
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
		}
	}
}

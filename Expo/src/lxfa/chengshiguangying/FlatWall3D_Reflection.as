package lxfa.chengshiguangying{
    import caurina.transitions.*;
    
    import communication.MainSystem;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.getQualifiedClassName;
    
    import lxfa.model.ItemModel;
    import lxfa.shanshuishihua.model.ShanShuiShiHuaModel;
    import lxfa.utils.MemoryRecovery;
    import lxfa.view.pv3dAddOn.milkmidi.papervision3d.materials.ReflectionFileMaterial;
    import lxfa.view.pv3dAddOn.org.papervision3d.objects.primitives.NumberPlane;
    
    import org.papervision3d.core.proto.MaterialObject3D;
    import org.papervision3d.events.*;
    import org.papervision3d.materials.*;
    import org.papervision3d.view.BasicView;
	//匯入筆者所撰寫的MiniSlider類別。
    public class FlatWall3D_Reflection extends Sprite 	{
		private var basicView			:BasicView;
		public  var cameraX			:Number = 900;	//camera的目標x軸
		private var cameraY			:Number = 200;	//camera的目標y軸
		private var cameraZ			:Number = -600;//camera的目標z軸
		private var cameraZMin		:Number = -1500;//cameraZ軸的最小值
		private var cameraZMax		:Number = -150;	//cameraZ軸的最大值
		private var secondLineHeight:int=   400;    //第二行的高度
		private var rubbishArray:Array;             //垃圾回收数组
		private var itemModel:ItemModel;    //
		private var materialRubbishArray:Array;
		private var pictureUrls:Array;
		private var customDown:CustomWindowUIDown;
		private var minMouseX:Number=173.7;//滑块的最小X坐标
		private var maxMouseX:Number=568.7;//滑块的最大X坐标
		private var offset:Number=5;    //点击左（右）按钮，滑块的偏移量
		private var ID:int;
        public function FlatWall3D_Reflection(ID:int){
        	this.ID=ID;
        	initPictureUrlCtr();
        }
        private function initPictureUrlCtr():void
        {
        	itemModel=new ItemModel("NormalWindow");
        	onPictureUrlCtrComplete(null);
        }
        private function onPictureUrlCtrComplete(e:Event):void
        {
        	this.pictureUrls=itemModel.getPictureUrls(ID);
        	initRubbishArray();
			init3DEngine();
			initObject();
        }
        private function initRubbishArray():void
        {
        	rubbishArray=new Array();
        	materialRubbishArray=new Array();
        }
		private function init3DEngine():void{
			basicView = new BasicView(751, 224, false , true, "FREECAMERA3D");
			basicView.viewport.buttonMode = true;
			basicView.x=20;
			this.addChild(basicView);
			initCustomDown();
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);			
			basicView.camera.z = -3500;
			basicView.camera.x = -1000;
		}
		private function initCustomDown():void
		{
			customDown=new CustomWindowUIDown();
			customDown.scaleX=customDown.scaleY=0.6;
			customDown.x=160;
			customDown.y=270;
			this.addChild(customDown);
			customDown.bar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler );
			customDown.bar.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler );
			customDown.left.addEventListener(MouseEvent.CLICK,onLeftClick);
			customDown.right.addEventListener(MouseEvent.CLICK,onRightClick);
		}
		//左边按钮的点击事件
		private function onLeftClick(e:MouseEvent):void
		{
			if(customDown.bar.x-offset>minMouseX)
			{
				customDown.bar.x-=offset;
				setCameraX();
			}
			else
			{
				customDown.bar.x=minMouseX;
			}
		}
		//右边按钮的点击事件
		private function onRightClick(e:MouseEvent):void
		{
			if(customDown.bar.x+offset<=maxMouseX)
			{
				customDown.bar.x+=offset;
				setCameraX();
			}
			else
			{
				customDown.bar.x=maxMouseX;
			}
		}
		private function onMouseDownHandler( e : MouseEvent ):void {
		       stage.addEventListener( MouseEvent.MOUSE_MOVE, onMoveHandler );
		       stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUpHandler );
		}
		
		private function onMouseUpHandler( e :MouseEvent ):void {
		       if ( stage.hasEventListener( MouseEvent.MOUSE_MOVE ) ) {
		              stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMoveHandler );
		       }
		       if ( stage.hasEventListener( MouseEvent.MOUSE_UP ) ) {
		              stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUpHandler );
		       }
		}
		private function onMoveHandler( e : MouseEvent ):void {
	       if( mouseX > minMouseX &&  mouseX < maxMouseX )
	       {
		       	customDown.bar.x = mouseX;
		       	setCameraX();
	       }
		}
		private function setCameraX():void
		{
			cameraX=(customDown.bar.x-minMouseX)/(maxMouseX-minMouseX)*1000;
		}
		private function initObject():void{
			init3DObject();
			this.addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(MouseEvent.CLICK,onStageClick);
			});
			//监听添加到STAGE得事件
		}
        private function onStageClick(e:MouseEvent):void
		{
			if(getQualifiedClassName(e.target)=="ShanShuiShiHuaSwc")
			{
				cameraX = 900;	//camera的目標x軸
				cameraY= 200;	//camera的目標y軸
				cameraZ= -1500;//camera的目標z軸
			}
		}
		private function init3DObject():void {
			var bmpMat		:MaterialObject3D;
			var planeHeight	:int;
			var imgUrl:String;
			//宣告變數, 避免在判斷式時重復宣告。
			for (var i:int = 0; i < pictureUrls.length; i++) {	
				imgUrl=pictureUrls[i];
				if (i % 2 == 0) {	
					//取 3 餘數如果等於 0 的話, 表示是最下方一排					
					bmpMat = new ReflectionFileMaterial(imgUrl, true);
					//反射材質
					planeHeight = 400;
					//因為使用反射材質, 所以高度要增加一倍					
				}else {
					bmpMat = new BitmapFileMaterial(imgUrl);
					planeHeight = 240;
					//使用本來的點陣圖材質和高度
				}				
				bmpMat.interactive = true;
				bmpMat.smooth = true;		
				materialRubbishArray.push(bmpMat);		
				var plane:NumberPlane=new NumberPlane(bmpMat, 320, planeHeight, 4, 4);
				plane.x =Math.floor(i/2)* 360;
				plane.y = i % 2 * secondLineHeight;	
				plane.setID(itemModel.getMin()+i);
				//修正反射Plane物件的y軸。				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onEvent3DOver);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onEvent3DOut);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onEvent3DClick);
				basicView.scene.addChild(plane);
				rubbishArray.push(plane);	
			}
		}
		private function onMouseWheel(e:MouseEvent):void {
			//用 MouseEvent 類別下的 delta 屬性可以得到滑鼠滾輪的值
			//e.dalta如果大於0,表示滾輪向上,小於0表示向下。			
			cameraZ = basicView.camera.z + (e.delta * 100);
			//將 camera 要移動到的目標 z 軸值寫入至 cameraZ 變數裡
			if (cameraZ < cameraZMin) {
				cameraZ = cameraZMin
			}else if(cameraZ > cameraZMax){
				cameraZ = cameraZMax
			}
			//判斷目標 z 軸值是否小於最小值或是大於最大值, 再決定 camera 要移動到的目標			
		}
		private function onEvent3DOver(e:InteractiveScene3DEvent):void {
			//當滑鼠滑入感應區時, 讓廣播者物件稍往前移
			Tweener.addTween( e.displayObject3D,{
                z		: -10,
                time	:1
			});
		}
		private function onEvent3DOut(e:InteractiveScene3DEvent):void {
			//當滑鼠離開感應區, 讓廣播者的 z 軸回復到 0
			Tweener.addTween( e.displayObject3D,{
                z		: 0,
                time	:1
			});
		}
		private function onEvent3DClick(e:InteractiveScene3DEvent):void{
			var _target:NumberPlane = e.displayObject3D as NumberPlane;
			//當使用者點選圖片時, 先取得廣播者 (被點選者),
			//其x,y,z屬性即是Camera的目標值,
			//z軸要多減去200,讓Camera可以往後一點
			cameraX = _target.x;
			cameraY = _target.y;
			cameraZ = _target.z -150;
			if(_target.y==0)
			{
				cameraY+=80;
			}  
            MainSystem.getInstance().runAPIDirect("showNormalWindow",[_target.getID()]);
			basicView.stopRendering();
		}
		private function onBackGroundClick(e:MouseEvent):void{
			cameraZ = -1000;
			//目標Z軸回到-1000;
//			bg_mc.removeEventListener(MouseEvent.CLICK, onBackGroundClick);
			//取消偵聽。
		}

        private function onEventRender3D(e:Event):void{		
        	if(basicView!=null)
        	{
				var _incrementX:Number = (cameraX - basicView.camera.x) / 20;
				//算出x軸的移動量			
				var _incrementRotation:Number = (_incrementX - basicView.camera.rotationY) / 20;
				//把 x 軸的移動量當成 rotationY 的目標值, 套入至漸進公式裡 
				//這樣可以做出 Camera 到達到目標 x 軸後, 再慢慢轉正的效果
				basicView.camera.rotationY += _incrementRotation;
				
				basicView.camera.x += _incrementX;
				// x 軸的漸進公式
				basicView.camera.y += (cameraY - basicView.camera.y) / 20;
				// y 軸的漸進公式
				basicView.camera.z += (cameraZ - basicView.camera.z) / 20;
				// z 軸的漸進公式
	        	basicView.singleRender();
        	}	
        }
        public function dispose():void
        {
        	MemoryRecovery.getInstance().gcFun(stage,MouseEvent.MOUSE_MOVE, onMoveHandler );
        	MemoryRecovery.getInstance().gcFun(stage,MouseEvent.MOUSE_UP, onMouseUpHandler );
        	MemoryRecovery.getInstance().gcFun(stage,MouseEvent.MOUSE_WHEEL, onMouseWheel);
        	MemoryRecovery.getInstance().gcFun(stage,MouseEvent.CLICK,onStageClick);
        	MemoryRecovery.getInstance().gcFun(this,Event.ENTER_FRAME, onEventRender3D);	
        	MemoryRecovery.getInstance().gcFun(itemModel,Event.COMPLETE,onPictureUrlCtrComplete);
        	MemoryRecovery.getInstance().gcObj(itemModel,true);
        	for each(var m:MaterialObject3D in materialRubbishArray)
        	{
        		if(m!=null)
        		{
        			m.destroy();
        		}
        	}
        	var i:int=0;
        	for(i=0;i<rubbishArray.length;i++)
        	{
        		MemoryRecovery.getInstance().gcFun(rubbishArray[i],InteractiveScene3DEvent.OBJECT_OVER, onEvent3DOver);
        		MemoryRecovery.getInstance().gcFun(rubbishArray[i],InteractiveScene3DEvent.OBJECT_OUT, onEvent3DOut);
        		MemoryRecovery.getInstance().gcFun(rubbishArray[i],InteractiveScene3DEvent.OBJECT_CLICK, onEvent3DClick);
        		MemoryRecovery.getInstance().gcObj(rubbishArray[i]);
        	}
        	basicView.renderer.destroy();
        	basicView=null;
        }
    }
}

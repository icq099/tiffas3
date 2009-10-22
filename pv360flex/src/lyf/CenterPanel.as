package lyf{ 
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CenterPanel extends Sprite
	{
		private var cpp:CenterPanelPlugin=null;
		private var defaultAplha:Number=0.4;
		private var mouseOverAplha:Number=0.8;
		private var cameraRotateSpeed:int=8;
		private var focusSpeed:int=10;
		private const focusMaxRange:int=130;
		private const focusMinRange:int=60;
		public function CenterPanel()
		{
			MainSystem.getInstance().camera.focus=95;
			cpp=new CenterPanelPlugin();
			addCppButtonClickEvent();
			addCppButtonLeaveEvent();
			addCppButtonOverEvent();
			setCppButtonAlpha();
			addCppButtonTooltip();
			this.addChild(cpp);
			
		}
		//----------------给所有按钮添加tooltip------------------
		private function addCppButtonTooltip():void
		{
			ToolTip.init(cpp);
			//与显示元素关联。  
			ToolTip.register(cpp.all, "全屏");  
			ToolTip.register(cpp.shape, "小地图"); 
			ToolTip.register(cpp.fish, "标本");
			ToolTip.register(cpp.up, "镜头向上");
			ToolTip.register(cpp.down, "镜头向下");
			ToolTip.register(cpp.left, "镜头向左");
			ToolTip.register(cpp.right, "镜头向右");
			ToolTip.register(cpp.addCamera, "镜头前进");
			ToolTip.register(cpp.notAddCamera, "镜头后退");
		}
		//----------------给所有按钮添加“鼠标离开”的事件------------
		private function addCppButtonLeaveEvent():void
		{
			if(cpp!=null)
			{
				cpp.all.addEventListener(MouseEvent.MOUSE_OUT,allLeaveEvent);
				cpp.shape.addEventListener(MouseEvent.MOUSE_OUT,shapeLeaveEvent);
				cpp.fish.addEventListener(MouseEvent.MOUSE_OUT,fishLeaveEvent);
				cpp.up.addEventListener(MouseEvent.MOUSE_OUT,upLeaveEvent);
				cpp.down.addEventListener(MouseEvent.MOUSE_OUT,downLeaveEvent);
				cpp.left.addEventListener(MouseEvent.MOUSE_OUT,leftLeaveEvent);
				cpp.right.addEventListener(MouseEvent.MOUSE_OUT,rightLeaveEvent);
				cpp.addCamera.addEventListener(MouseEvent.MOUSE_OUT,addCameraLeaveEvent);
				cpp.notAddCamera.addEventListener(MouseEvent.MOUSE_OUT,notAddCameraLeaveEvent);
			}				
		}
		//给所有按钮添加鼠标经过时的事件
		private function addCppButtonOverEvent():void
		{
			if(cpp!=null)
			{
				cpp.all.addEventListener(MouseEvent.MOUSE_OVER,allOverEvent);
				cpp.shape.addEventListener(MouseEvent.MOUSE_OVER,shapeOverEvent);
				cpp.fish.addEventListener(MouseEvent.MOUSE_OVER,fishOverEvent);
				cpp.up.addEventListener(MouseEvent.MOUSE_OVER,upOverEvent);
				cpp.down.addEventListener(MouseEvent.MOUSE_OVER,downOverEvent);
				cpp.left.addEventListener(MouseEvent.MOUSE_OVER,leftOverEvent);
				cpp.right.addEventListener(MouseEvent.MOUSE_OVER,rightOverEvent);
				cpp.addCamera.addEventListener(MouseEvent.MOUSE_OVER,addCameraOverEvent);
				cpp.notAddCamera.addEventListener(MouseEvent.MOUSE_OVER,notAddCameraOverEvent);
			}			
		}
		//给所有按钮添加鼠标点击时的事件
		private function addCppButtonClickEvent():void
		{
			if(cpp!=null)
			{
				cpp.all.addEventListener(MouseEvent.CLICK,allClickEvent);
				cpp.shape.addEventListener(MouseEvent.CLICK,shapeClickEvent);
				cpp.fish.addEventListener(MouseEvent.CLICK,fishClickEvent);
				cpp.up.addEventListener(MouseEvent.CLICK,upClickEvent);
				cpp.down.addEventListener(MouseEvent.CLICK,downClickEvent);
				cpp.left.addEventListener(MouseEvent.CLICK,leftClickEvent);
				cpp.right.addEventListener(MouseEvent.CLICK,rightClickEvent);
				cpp.addCamera.addEventListener(MouseEvent.CLICK,addCameraClickEvent);
				cpp.notAddCamera.addEventListener(MouseEvent.CLICK,notAddCameraClickEvent);
			}
		}
		//设置所有按钮的透明度
		private function setCppButtonAlpha():void
		{
				cpp.all.alpha=defaultAplha;
				cpp.shape.alpha=defaultAplha;
				cpp.fish.alpha=defaultAplha;
				cpp.up.alpha=defaultAplha;
				cpp.down.alpha=defaultAplha;
				cpp.left.alpha=defaultAplha;
				cpp.right.alpha=defaultAplha;
				cpp.addCamera.alpha=defaultAplha;
				cpp.notAddCamera.alpha=defaultAplha;
		}
		//---------------------鼠标离开时的事件--------------
		private function allLeaveEvent(e:MouseEvent):void
		{
			cpp.all.alpha=defaultAplha;
		}
		private function shapeLeaveEvent(e:MouseEvent):void
		{
			cpp.shape.alpha=defaultAplha;
		}
		private function fishLeaveEvent(e:MouseEvent):void
		{
			cpp.fish.alpha=defaultAplha;
		}
		private function upLeaveEvent(e:MouseEvent):void
		{
			cpp.up.alpha=defaultAplha;
		}
		private function downLeaveEvent(e:MouseEvent):void
		{
			cpp.down.alpha=defaultAplha;
		}
		private function leftLeaveEvent(e:MouseEvent):void
		{
			cpp.left.alpha=defaultAplha;
		}
		private function rightLeaveEvent(e:MouseEvent):void
		{
			cpp.right.alpha=defaultAplha;
		}
		private function addCameraLeaveEvent(e:MouseEvent):void
		{
			cpp.addCamera.alpha=defaultAplha;
		}
		private function notAddCameraLeaveEvent(e:MouseEvent):void
		{
			cpp.notAddCamera.alpha=defaultAplha;
		}
		//---------------------鼠标经过时的事件--------------
		private function allOverEvent(e:MouseEvent):void
		{
			cpp.all.alpha=mouseOverAplha;
		}
		private function shapeOverEvent(e:MouseEvent):void
		{
			cpp.shape.alpha=mouseOverAplha;
		}
		private function fishOverEvent(e:MouseEvent):void
		{
			cpp.fish.alpha=mouseOverAplha;
		}
		private function upOverEvent(e:MouseEvent):void
		{
			cpp.up.alpha=mouseOverAplha;
		}
		private function downOverEvent(e:MouseEvent):void
		{
			cpp.down.alpha=mouseOverAplha;
		}
		private function leftOverEvent(e:MouseEvent):void
		{
			cpp.left.alpha=mouseOverAplha;
		}
		private function rightOverEvent(e:MouseEvent):void
		{
			cpp.right.alpha=mouseOverAplha;
		}
		private function addCameraOverEvent(e:MouseEvent):void
		{
			cpp.addCamera.alpha=mouseOverAplha;
		}
		private function notAddCameraOverEvent(e:MouseEvent):void
		{
			cpp.notAddCamera.alpha=mouseOverAplha;
		}
		//--------------------clickEvent---------------------------
		private function allClickEvent(e:MouseEvent):void
		{
			MainSystem.getInstance().fullScreen();
		}
		private function shapeClickEvent(e:MouseEvent):void
		{
			trace("all");
		}
		private function fishClickEvent(e:MouseEvent):void
		{
			trace("all");
		}
		private function upClickEvent(e:MouseEvent):void
		{
			MainSystem.getInstance().camera.rotationX+=cameraRotateSpeed;
		}
		private function downClickEvent(e:MouseEvent):void
		{
			MainSystem.getInstance().camera.rotationX-=cameraRotateSpeed;
		}
		private function leftClickEvent(e:MouseEvent):void
		{
			MainSystem.getInstance().camera.rotationY-=cameraRotateSpeed;
		}
		private function rightClickEvent(e:MouseEvent):void
		{
			MainSystem.getInstance().camera.rotationY+=cameraRotateSpeed;
		}
		private var tempFocus:int=0;
		private function addCameraClickEvent(e:MouseEvent):void
		{
			tempFocus=MainSystem.getInstance().camera.focus+focusSpeed;
			if(tempFocus<focusMaxRange)
			{
				MainSystem.getInstance().camera.focus+=focusSpeed;
			}
		}
		private function notAddCameraClickEvent(e:MouseEvent):void
		{
			tempFocus=MainSystem.getInstance().camera.focus-focusSpeed;
			if(tempFocus>focusMinRange)
			{
				MainSystem.getInstance().camera.focus-=focusSpeed;
			}
		}
	}
}

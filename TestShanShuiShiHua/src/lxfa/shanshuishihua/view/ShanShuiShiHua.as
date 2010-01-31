package lxfa.shanshuishihua.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ShanShuiShiHua extends Sprite
	{
		private var shanShuiShiHuaSwc:ShanShuiShiHuaSwc;
		private var flatWall:FlatWall3D_Reflection;
		private var minMouseX:Number=266;//滑块的最小X坐标
		private var maxMouseX:Number=510;//滑块的最大X坐标
		private var offset:Number=5;    //点击左（右）按钮，滑块的偏移量
		public function ShanShuiShiHua()
		{
			initShanShuiShiHuaSwc();
			initFlatWall3D_Reflection();
		}
		private function initShanShuiShiHuaSwc():void
		{
			shanShuiShiHuaSwc=new ShanShuiShiHuaSwc();
			this.addChild(shanShuiShiHuaSwc);
		}
		private function initFlatWall3D_Reflection():void
		{
			flatWall=new FlatWall3D_Reflection();
			flatWall.x=24;
			flatWall.y=90;
			shanShuiShiHuaSwc.addChild(flatWall);
			shanShuiShiHuaSwc.addChild(shanShuiShiHuaSwc.bottom);
			shanShuiShiHuaSwc.addChild(shanShuiShiHuaSwc.left);
			shanShuiShiHuaSwc.addChild(shanShuiShiHuaSwc.right);
			shanShuiShiHuaSwc.addChild(shanShuiShiHuaSwc.scrubber);
			shanShuiShiHuaSwc.scrubber.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDownHandler );
			shanShuiShiHuaSwc.scrubber.addEventListener( MouseEvent.MOUSE_UP, onMouseUpHandler );
			shanShuiShiHuaSwc.left.addEventListener(MouseEvent.CLICK,onLeftClock);
			shanShuiShiHuaSwc.right.addEventListener(MouseEvent.CLICK,onRightClick);
		}
		//左边按钮的点击事件
		private function onLeftClock(e:MouseEvent):void
		{
			if(shanShuiShiHuaSwc.scrubber.x-offset>minMouseX)
			{
				shanShuiShiHuaSwc.scrubber.x-=offset;
				setCameraX();
			}
			else
			{
				shanShuiShiHuaSwc.scrubber.x=minMouseX;
			}
		}
		//右边按钮的点击事件
		private function onRightClick(e:MouseEvent):void
		{
			if(shanShuiShiHuaSwc.scrubber.x+offset<=maxMouseX)
			{
				shanShuiShiHuaSwc.scrubber.x+=offset;
				setCameraX();
			}
			else
			{
				shanShuiShiHuaSwc.scrubber.x=maxMouseX;
			}
		}
		private function onMouseDownHandler( e : MouseEvent ):void {
		       stage.addEventListener( MouseEvent.MOUSE_MOVE, onMoveHandler );
		       stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUpHandler );
		}
		
		private function onMouseUpHandler( e : MouseEvent ):void {
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
			       	shanShuiShiHuaSwc.scrubber.x = mouseX;
			       	setCameraX();
		       }
		}
		private function setCameraX():void
		{
			flatWall.cameraX=(shanShuiShiHuaSwc.scrubber.x-minMouseX)/(maxMouseX-minMouseX)*4000;
		}
	}
}
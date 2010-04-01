package lxfa.shanshuishihua.view
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.utils.MemoryRecovery;
	public class ShanShuiShiHua extends Sprite
	{
		private var shanShuiShiHuaSwc:ShanShuiShiHuaSwc;
		private var flatWall:FlatWall3D_Reflection;
		private var minMouseX:Number=266;//滑块的最小X坐标
		private var maxMouseX:Number=510;//滑块的最大X坐标
		private var offset:Number=5;    //点击左（右）按钮，滑块的偏移量
		public function ShanShuiShiHua()
		{
			MainSystem.getInstance().addAPI("getShanShuiShiHua",initShanShuiShiHuaSwc);
		}
		private function initShanShuiShiHuaSwc():ShanShuiShiHuaSwc
		{
			MainSystem.getInstance().stopRender();
			shanShuiShiHuaSwc=new ShanShuiShiHuaSwc();
			initFlatWall3D_Reflection();
			return shanShuiShiHuaSwc;
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
			shanShuiShiHuaSwc.left.addEventListener(MouseEvent.CLICK,onLeftClick);
			shanShuiShiHuaSwc.right.addEventListener(MouseEvent.CLICK,onRightClick);
			shanShuiShiHuaSwc.close.addEventListener(MouseEvent.CLICK,onCloseClick);
		}
		//关闭按钮点击事件
		private function onCloseClick(e:MouseEvent):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				shanShuiShiHuaSwc.dispatchEvent(new Event(Event.CLOSE));
				MainSystem.getInstance().runAPIDirectDirectly("removePluginById",["ShanShuiShiHuaModule"]);
			}
		}
		//左边按钮的点击事件
		private function onLeftClick(e:MouseEvent):void
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
			flatWall.cameraX=(shanShuiShiHuaSwc.scrubber.x-minMouseX)/(maxMouseX-minMouseX)*1000;
		}
		public function dispose():void
		{
			MainSystem.getInstance().startRender();
			MemoryRecovery.getInstance().gcFun(shanShuiShiHuaSwc.scrubber,MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			MemoryRecovery.getInstance().gcFun(shanShuiShiHuaSwc.scrubber,MouseEvent.MOUSE_UP,onMouseUpHandler);
			MemoryRecovery.getInstance().gcObj(shanShuiShiHuaSwc.scrubber);
			MemoryRecovery.getInstance().gcFun(shanShuiShiHuaSwc.left,MouseEvent.CLICK,onLeftClick);
			MemoryRecovery.getInstance().gcFun(shanShuiShiHuaSwc.right,MouseEvent.CLICK,onRightClick);
			MemoryRecovery.getInstance().gcFun(shanShuiShiHuaSwc.close,MouseEvent.CLICK,onCloseClick);
			MemoryRecovery.getInstance().gcObj(shanShuiShiHuaSwc.left);
			MemoryRecovery.getInstance().gcObj(shanShuiShiHuaSwc.right);
			MemoryRecovery.getInstance().gcObj(shanShuiShiHuaSwc.close);
			MemoryRecovery.getInstance().gcObj(shanShuiShiHuaSwc);
			MemoryRecovery.getInstance().gcObj(flatWall,true);
		}
	}
}
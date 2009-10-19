package
{
	import communication.MainSystem;
	import communication.camera.CameraProxy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PluginTest extends Sprite
	{
		private var control:ControlCameraSkin=new ControlCameraSkin();
		private var camera:CameraProxy;
		public function PluginTest()
		{
			super();
			camera=MainSystem.getInstance().camera;
			addChild(control);
			control.up.addEventListener(MouseEvent.CLICK,onUpClick);
			control.left.addEventListener(MouseEvent.CLICK,onLeftClick);
			control.right.addEventListener(MouseEvent.CLICK,onRtightClick);
			control.down.addEventListener(MouseEvent.CLICK,onDownClick);
		}
		private function onUpClick(e:Event):void{
			camera.rotationX+=10;
		}
		private function onLeftClick(e:Event):void{
			camera.rotationY-=10;
		}
		private function onRtightClick(e:Event):void{
			camera.rotationY+=10;
		}
		private function onDownClick(e:Event):void{
			camera.rotationX-=10;
		}
		
	}
}
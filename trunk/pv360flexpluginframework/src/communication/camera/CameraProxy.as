package communication.camera
{
	import communication.MainSystem;
	
	import flash.events.EventDispatcher;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.FreeCamera3D;

	public class CameraProxy extends EventDispatcher
	{
		private var camera:FreeCamera3D;
		public function CameraProxy(camera:FreeCamera3D)
		{
			super(this);
			this.camera=camera;
		}
		public function set focus(value:Number):void{
			camera.focus=value;
		}
		public function get focus():Number{
			return camera.focus;
		}
		public function set zoom(value:Number):void{
			camera.zoom=value;
		}
		public function get zoom():Number{
			return camera.zoom;
		}
		public function set rotationX(value:Number):void{
			MainSystem.getInstance().setCameraRotaion(value-camera.rotationX);
		}
		public function get rotationX():Number{
			return camera.rotationX;
		}
		public function set rotationY(value:Number):void{
			MainSystem.getInstance().setCameraRotaion(0,value-camera.rotationY);
		}
		public function get rotationY():Number{
			return camera.rotationY;
		}
	}
}
package other
{
	import org.papervision3d.cameras.FreeCamera3D;

	public class FreeEventCamera extends FreeCamera3D
	{
		public function FreeEventCamera(zoom:Number=2, focus:Number=100, initObject:Object=null)
		{
			super(zoom, focus, initObject);
		}
		override public function set rotationX(rot:Number):void{
			
			super.rotationX=rot;
			dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROTATION_CHANGE));
		
		}
		override public function set rotationY(rot:Number):void{
			
			super.rotationY=rot;
			dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROTATION_CHANGE));
		
		}
		override public function set rotationZ(rot:Number):void{
			
			super.rotationZ=rot;
			dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROTATION_CHANGE));
		
		}
		
	}
}
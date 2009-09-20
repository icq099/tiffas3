package model
{
	import other.FreeEventCamera;
	
	public class Travel
	{
		//public var camera:Object=new FreeEventCamera(7.1,62.2);
		public var camera:Object=new FreeEventCamera(8,80);
		public var current_scene:int=-1;
		public var menu_count:int=0;
		public function Travel()
		{
			camera.z=0;
		}
 
	}
}
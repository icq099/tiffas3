package lxfa.shanshuishihua.view
{
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	public class NumberPlane extends Plane
	{
		private var ID:int=-1;
		public function NumberPlane(bmpMat:MaterialObject3D, width:int, height:int, i:int, j:int)
		{
			super(bmpMat,width,height,i,j);
		}
		public function setID(ID:int):void
		{
			this.ID=ID;
		}
		public function getID():int
		{
			return this.ID;
		}
	}
}
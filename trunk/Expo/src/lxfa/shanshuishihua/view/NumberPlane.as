package lxfa.shanshuishihua.view
{
	//"山水诗画"里面的3D平面,带ID，ID可以用来显示具体的内容
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	public class NumberPlane extends Plane
	{
		private var ID:int=-1;//初始ID为-1
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
package
{
	import com.as3dmod.ModifierStack;
	import com.as3dmod.modifiers.Bend;
	import com.as3dmod.plugins.pv3d.LibraryPv3d;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Plane;

	public class BendPlane extends Plane
	{
		private var modifi:ModifierStack;
		private var bend:Bend;
		public function BendPlane(material:MaterialObject3D=null, width:Number=0, height:Number=0, segmentsW:Number=0, segmentsH:Number=0, initObject:Object=null)
		{
			super(material, width, height, segmentsW, segmentsH, initObject);
			modifi=new ModifierStack(new LibraryPv3d(),this);
			bend=new Bend();
			if(height>width){
				bend.switchAxes=true;
			}
			modifi.addModifier(bend);
		}
		public function set offset(value:Number):void{
			bend.offset=value;
			modifi.apply();
		}
		public function get offset():Number{
			return bend.offset;
		}
		public function set force(value:Number):void{
			bend.force=value;
			modifi.apply();
		}
		public function get force():Number{
			return bend.force;
		}
		public function set angle(value:Number):void{
			bend.angle=value;
			modifi.apply();
		}
		public function get angle():Number{
			return bend.angle;
		}
	}
}
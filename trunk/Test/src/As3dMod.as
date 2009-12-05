package
{
	import com.as3dmod.ModifierStack;
	import com.as3dmod.modifiers.Bend;
	import com.as3dmod.plugins.pv3d.LibraryPv3d;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	
	import yzhkof.BasicAsProject;

	public class As3dMod extends BasicAsProject
	{
		public function As3dMod()
		{
			var b:BasicView=new BasicView(642,320,true,false,FreeCamera3D.TYPE);
			var p:Plane=new Plane(null,3000,2000,50,50);
			p.material=new WireframeMaterial();
			p.material.doubleSided=true;
			addChild(b);
			b.scene.addChild(p);
			b.startRendering();
			var m:ModifierStack=new ModifierStack(new LibraryPv3d(),p);
			m.addModifier(new Bend(1,0,0));
			m.apply();
		}
		
	}
}
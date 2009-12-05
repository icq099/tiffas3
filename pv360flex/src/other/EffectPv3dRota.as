package other
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import gs.TweenLite;
	
	import mx.core.UIComponent;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.view.BasicView;
	
	import view.struct.BendPlane;
	
	import yzhkof.Toolyzhkof;
	import yzhkof.effect.EffectBitmapBase;

	public class EffectPv3dRota extends EffectBitmapBase
	{
		public static const TYPE_LEFT:Number=0;
		public static const TYPE_RIGHT:Number=Math.PI;
		public static const TYPE_UP:Number=-Math.PI/2;
		public static const TYPE_DOWN:Number=Math.PI/2;
		private var view_port:BasicView;
		private var plane:BendPlane;
		private var material:MaterialObject3D;
		private var angle:Number;
		private var startForce:Number;
		private var stopForce:Number;
		private var duration:Number;
		private var ui_com:UIComponent;
		public function EffectPv3dRota(container:DisplayObjectContainer, effector:DisplayObject,duration:Number=1,angle:Number=0,startForce:Number=0.5,stopForce:Number=0)
		{
			super(container, effector);
			this.angle=angle;
			this.startForce=startForce;
			this.stopForce=stopForce;
			this.duration=duration;
		}
		protected override function onEffectStart():void{
			view_port=new BasicView(effector.width*2,effector.height*2,false);
			material=new BitmapMaterial(effector_bitmap.bitmapData);
			//material=new WireframeMaterial();
			material.doubleSided=true;
			plane=new BendPlane(material,effector.width,effector.height,10,10);
			plane.offset=0;
			view_port.scene.addChild(plane);
			if(isFlex){
				container.addChild(ui_com=Toolyzhkof.mcToUI(view_port));
			}else{
				container.addChild(view_port);
			}
			view_port.startRendering();
			view_port.x=effector.x-effector.width/2;
			view_port.y=effector.y-effector.height/2;
			plane.angle=angle;
			plane.force=startForce;
			TweenLite.to(plane,duration,{force:stopForce});
			TweenLite.from(view_port,duration,{alpha:0,onComplete:function():void{
				if(isFlex){
					container.removeChild(ui_com);
				}else{
					container.removeChild(view_port);
				}
				view_port.stopRendering();
				material.destroy();
				onEffectComplete();
			}});
		}
		
	}
}
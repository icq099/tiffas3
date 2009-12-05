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
		public static const ANGLE_LEFT:Number=0;
		public static const ANGLE_RIGHT:Number=Math.PI;
		public static const ANGLE_UP:Number=-Math.PI/2;
		public static const ANGLE_DOWN:Number=Math.PI/2;
		private var view_port:BasicView;
		private var plane:BendPlane;
		private var material:MaterialObject3D;
		private var angle:Number;
		private var startForce:Number;
		private var stopForce:Number;
		private var duration:Number;
		private var ui_com:UIComponent;
		private var easeIn:Boolean;
		public function EffectPv3dRota(container:DisplayObjectContainer, effector:DisplayObject,duration:Number=1,easeIn:Boolean=true,angle:Number=0,startForce:Number=0.5,stopForce:Number=0)
		{
			super(container, effector);
			this.angle=angle;
			this.startForce=startForce;
			this.stopForce=stopForce;
			this.duration=duration;
			this.easeIn=easeIn
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
			TweenLite.to(plane,duration,{force:stopForce,onComplete:function():void{
				cancel();
			}});
			if(easeIn){
				TweenLite.from(view_port,duration,{alpha:0});
			}else{
				TweenLite.to(view_port,duration,{alpha:0});
			}
		}
		public override function cancel():void{
			try{
				if(isFlex){
					container.removeChild(ui_com);
				}else{
					container.removeChild(view_port);
				}
			}catch(e:Error){
			}
			TweenLite.killTweensOf(plane);
			TweenLite.killTweensOf(view_port);
			view_port.stopRendering();
			material.destroy();
			super.cancel();
		}
		
	}
}
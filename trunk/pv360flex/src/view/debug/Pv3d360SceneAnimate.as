package view.debug
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import gs.TweenLite;
	
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.primitives.Plane;
	
	import view.Pv3d360Scene;
	
	import yzhkof.debug.debugTrace;

	public class Pv3d360SceneAnimate extends Pv3d360Scene
	{
		protected var _mouse3D:Mouse3D;
		protected var debug_plane:Plane;
		
		public function Pv3d360SceneAnimate(czoom:Number=11, pdetail:Number=50)
		{
			super(czoom, pdetail);
		}
		override protected function init():void{
			
			super.init();
			
			Mouse3D.enabled=true;
			
			_mouse3D = viewport.interactiveSceneManager.mouse3D;
			TweenLite.delayedCall(8,function():void{
			
				debug_plane=addAminate("animate/A.swf",{width:1000,height:1000,x:0,y:0,z:1000});
			
			})
		
		}
		override protected function chageCompleteHandler(e:Event):void{
			
			super.chageCompleteHandler(e);
			
			sphere.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,function(e:Event):void{
				
				debug_plane.x=_mouse3D.x;
				debug_plane.y=_mouse3D.y;
				debug_plane.z=_mouse3D.z;				
			
			})
			material.interactive=true;
			stage.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void{
				
				if(e.keyCode==Keyboard.LEFT){
					
					debug_plane.scaleX+=0.01;
				
				}
				if(e.keyCode==Keyboard.RIGHT){
					
					debug_plane.scaleX-=0.01;
				
				}
				if(e.keyCode==Keyboard.UP){
					
					debug_plane.scaleY+=0.01;
				
				}
				if(e.keyCode==Keyboard.DOWN){
					
					debug_plane.scaleY-=0.01;
				
				}
				if(e.keyCode==87){
					
					debug_plane.rotationX+=0.3;
				
				}
				if(e.keyCode==83){
					
					debug_plane.rotationX-=0.3;
				
				}
				if(e.keyCode==65){
					
					debug_plane.rotationY+=0.3;
				
				}
				if(e.keyCode==68){
					
					debug_plane.rotationY-=0.3;
				
				}
				if(e.keyCode==103){
					
					debug_plane.x+=0.5;
				
				}
				if(e.keyCode==104){
					
					debug_plane.x-=0.5;
				
				}
				if(e.keyCode==100){
					
					debug_plane.y+=0.5;
				
				}
				if(e.keyCode==101){
					
					debug_plane.y-=0.5;
				
				}
				if(e.keyCode==97){
					
					debug_plane.z+=0.5;
				
				}
				if(e.keyCode==98){
					
					debug_plane.z-=0.5;
				
				}
				
				if(e.keyCode==Keyboard.ENTER){
					
					draw();
				
				}
				
				if(e.keyCode==Keyboard.SPACE){
										
					debugTrace("x=\""+debug_plane.x+"\"",
					"y=\""+debug_plane.y+"\"",
					"z=\""+debug_plane.z+"\"",
					"width=\""+debug_plane.scaleX*1000+"\"",
					"height=\""+debug_plane.scaleY*1000+"\"",
					"rotationX=\""+debug_plane.rotationX+"\"",
					"rotationY=\""+debug_plane.rotationY+"\"");
				
				}
			
			})
		
		}
	}
}
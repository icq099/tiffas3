package view.debug
{
	import flash.events.Event;
	
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	import view.Pv3d360Scene;
	
	import yzhkof.debug.debugTrace;

	public class Pv3d360SceneHotPoint extends Pv3d360Scene
	{
		private var _mouse:Mouse3D;
		public function Pv3d360SceneHotPoint(czoom:Number=11, pdetail:Number=50)
		{
			super(czoom, pdetail);
		}
		protected override function init():void{
			super.init();
			Mouse3D.enabled=true;
			
			_mouse=viewport.interactiveSceneManager.mouse3D;
			
			sphere.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,onMouseClick);
		}
		protected override function chageCompleteHandler(e:Event):void{
			super.chageCompleteHandler(e);
			material.interactive=true;
		}
		private function onMouseClick(e:Event):void{
			debugTrace("x=\""+_mouse.x+"\"","y=\""+_mouse.y+"\"","z=\""+_mouse.z+"\"");	
		}
	}
}
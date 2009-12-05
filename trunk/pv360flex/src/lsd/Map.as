package lsd
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import lsd.myview.NewMap;
	
	import other.EffectPv3dRota;
	
	import yzhkof.effect.MyEffect;

	public class Map extends Sprite
	{
		private var a:NewMap;
		public function Map()
		{
			this.filters=[new DropShadowFilter(10,45,0,0.5,10,10,1,3)];
			a=new NewMap();
			//addChild(a);
			MainSystem.getInstance().addAPI("showMap",showMap);
			MainSystem.getInstance().addAPI("removeMap",removeMap);
			a.addEventListener(Event.CLOSE,onClose);
			
		}
		private function onClose(e:Event):void{
			 removeMap();
		}
		private function showMap():void{
			MyEffect.addChild(new EffectPv3dRota(this,a,1,true,EffectPv3dRota.ANGLE_DOWN));
			
		}
		private function removeMap():void{
			
			MyEffect.removeChild(new EffectPv3dRota(this,a,1,false,-1.1,0,-0.5));
		}
	}
}

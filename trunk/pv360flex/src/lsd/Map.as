package lsd
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			a.mapDirector.title.addEventListener(MouseEvent.MOUSE_DOWN, dragMovie);
			a.mapDirector.title.addEventListener(MouseEvent.MOUSE_UP, dropMovie);
			a.mapDirector.title.buttonMode=true;
			
		}
		private function onClose(e:Event):void{
			 removeMap();
		}
		private function showMap():void{
			MyEffect.addChild(new EffectPv3dRota(this,a,1,true,1));
			
		}
		private function removeMap():void{
			
			MyEffect.removeChild(new EffectPv3dRota(this,a,1,false,-0.8,0,-0.2));
		}
		
		private function dragMovie(event:MouseEvent):void
		{
			this.startDrag();
		}

		private function dropMovie(event:MouseEvent):void
		{
			this.stopDrag();
		}
	}
}

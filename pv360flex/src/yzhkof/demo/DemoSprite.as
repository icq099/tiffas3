package yzhkof.demo
{
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	import gs.easing.Quint;
	
	import yzhkof.util.delayCallNextFrame;

	public class DemoSprite extends Sprite
	{
		private var logo:Sprite=new LogoDemo();
		private var panel:Sprite=new Pictures();
		private var map:Dictionary=new Dictionary();
		public function DemoSprite()
		{
			addChild(panel);
			addChild(logo);
			panel.visible=false;
			panel.x=30;
			panel.y=50;
			delayCallNextFrame(init);
		}
		private function init():void{
			logo.addEventListener(MouseEvent.CLICK,onLogoClick);
			logo.addEventListener(MouseEvent.ROLL_OVER,onLogoOver);
			//panel.addEventListener(MouseEvent.MOUSE_OUT,onPanelMouseOut);
			for (var i:int=0;i<panel.numChildren;i++){
				var dobj:Sprite=panel.getChildAt(i) as Sprite;
				map[dobj]={x:dobj.x,y:dobj.y,scene:MovieClip(dobj).scene};
				dobj.addEventListener(MouseEvent.CLICK,function(e:Event):void{
					MainSystem.getInstance().gotoScene(map[e.currentTarget].scene);
					unPopPictures();
				});
			}
		}
		private function onLogoClick(e:Event):void{
			unPopPictures();
		}
		private function onLogoOver(e:Event):void{
			popUpPictures();	
		}
		private function popUpPictures():void{
			panel.visible=true;
			for (var i:int=0;i<panel.numChildren;i++){
				var dobj:DisplayObject=panel.getChildAt(i);
				dobj.x=-100;
				dobj.y=-100;
				dobj.alpha=-0.5;
				dobj.z=0;
				TweenLite.to(dobj,1+i*0.05,{ease:Quint.easeInOut,alpha:1,x:map[dobj].x,y:map[dobj].y});
			}
		}
		private function unPopPictures():void{
			for (var i:int=0;i<panel.numChildren;i++){
				TweenLite.to(panel.getChildAt(i),0.5,{alpha:0,z:100});
			}
		}
	}
}
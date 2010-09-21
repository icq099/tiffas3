package yzhkof.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import gs.TweenLite;

	public function locate(container:DisplayObjectContainer,x:Number,y:Number):void
	{
		var locatePoint:Sprite = new Sprite;
		locatePoint.graphics.lineStyle(3,0xff0000);
		locatePoint.graphics.drawCircle(0,0,100);
		locatePoint.graphics.drawCircle(0,0,2);
		locatePoint.x = x;
		locatePoint.y = y;
		container.addChild(locatePoint);
		TweenLite.to(locatePoint,3,{width:0,height:0,onComplete:function():void{container.removeChild(locatePoint)}});
	}
}
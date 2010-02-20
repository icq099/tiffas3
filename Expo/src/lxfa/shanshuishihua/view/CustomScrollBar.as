package lxfa.shanshuishihua.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.core.Application;
	
	public class CustomScrollBar extends Sprite
	{
		private var normalWindowSwc:NormalWindowSwc//标准窗的引用
		private var minMouseY:int;//鼠标点击的有效范围的最小值
		private var maxMouseY:int;//鼠标点击的有效范围的最大值
		private var center:ScrollCenter;
		public function CustomScrollBar(dp:NormalWindowSwc,text:String)
		{
			normalWindowSwc=dp;
			initText(text);
			initScrollCenter();
			initScrollDown();
			initScrollUp();
		}
		//初始化“下降按钮”
		private function initScrollDown():void
		{
			maxMouseY=normalWindowSwc.scrollDown.y-center.height-8;
			normalWindowSwc.scrollDown.addEventListener(MouseEvent.CLICK,onScrollDownClick);
		}
		//"下降按钮"的点击事件
		private function onScrollDownClick(e:MouseEvent):void
		{
			if(normalWindowSwc.text.scrollV<normalWindowSwc.text.numLines)
			{
				normalWindowSwc.text.scrollV+=1;
				updateScrollCenterLocation();
			}
		}
		//初始化"上升按钮"
		private function initScrollUp():void
		{
			minMouseY=normalWindowSwc.scrollUp.y+normalWindowSwc.scrollUp.height-8;
			normalWindowSwc.scrollUp.addEventListener(MouseEvent.CLICK,onScrollUpClick);
		}
		//"上升按钮"的点击事件
		private function onScrollUpClick(e:MouseEvent):void
		{
			if(normalWindowSwc.text.scrollV>1)
			{
				normalWindowSwc.text.scrollV-=1;
				updateScrollCenterLocation();
			}
		}
		//加载文本
		private function initText(text:String):void
		{
			if(text==null)
			{
				normalWindowSwc.text.text="";
			}
			else
			{
				normalWindowSwc.text.text=text;
			}
		}
		private function initScrollCenter():void
		{
			center=new ScrollCenter();
			center.x=784;
			center.y=85;
			this.addChild(center);
			if(normalWindowSwc.text.maxScrollV<normalWindowSwc.text.numLines)
			{
				center.visible=true;
			}
			else
			{
				center.visible=false;
			}
			center.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		}
		private function onMouseDownHandler( e : MouseEvent ):void {
			   center.startDrag(true,new Rectangle(center.x,minMouseY,0,maxMouseY-minMouseY));
		       Application.application.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMoveHandler );
		       Application.application.stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUpHandler );
		}
		
		private function onMouseUpHandler( e : MouseEvent ):void {
			   center.stopDrag();
		       if ( Application.application.stage.stage.hasEventListener( MouseEvent.MOUSE_MOVE ) ) {
		             Application.application.stage.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMoveHandler );
		       }
		       if ( Application.application.stage.stage.hasEventListener( MouseEvent.MOUSE_UP ) ) {
		              Application.application.stage.stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUpHandler );
		       }
		}
		private function onMoveHandler( e : MouseEvent ):void {
		       if( mouseY > minMouseY &&  mouseY < maxMouseY )
		       {
			       	updateText();
		       }
		}
		private function updateText():void
		{
			var scrollHeight:Number=maxMouseY-minMouseY;//滚动条的长度
			var distance:Number=center.y-minMouseY;//滑块与上面按钮的距离
			normalWindowSwc.text.scrollV=distance/scrollHeight*normalWindowSwc.text.numLines;
		}
		private function updateScrollCenterLocation():void
		{
			var scrollHeight:Number=maxMouseY-minMouseY;//滚动条的长度
			center.y=normalWindowSwc.text.scrollV/normalWindowSwc.text.maxScrollV*scrollHeight+minMouseY;
		}
	}
}
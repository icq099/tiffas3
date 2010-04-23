package view.decorator
{
	import flash.events.MouseEvent;
	
	/**
	 * 把指定的对象（target）装饰为滚动条
	 * 指定的对象必须实现ICustomScrollBarDecorator接口，否则报错
	 */
	public class CustomScrollBarDecorator
	{
		private var target:ICustomScrollBarDecorator;
		public function CustomScrollBarDecorator(target:*)
		{
			if(target is ICustomScrollBarDecorator)
			{
				this.target=ICustomScrollBarDecorator(target);
				init();
			}else
			{
				throw new Error("指定的对象必须实现ICustomScrollBarDecorator接口");
			}
		}
		private function init():Boolean
		{
			if(target==null)
			{
				trace("CustomScrollBarDecorator:传入的对象不能为空");
				return false;
			}
			if(target.textField==null)
			{
				trace("CustomScrollBarDecorator:指定的文本为空或文本不是TextField");
				return false;
			}
			if(target.point1==null || target.point2==null)
			{
				trace("CustomScrollBarDecorator:节点不能为空");
				return false;
			}
			if(target.point1.x!=target.point2.x 
            && target.point1.y!=target.point2.y)
			{
				trace("CustomScrollBarDecorator:point1中的值必须和point2中的其中一个值匹配");
				return false;
			}
			if(target.textField.maxScrollV==0)
			{
				trace("CustomScrollBarDecorator:不需要添加文本滚动");
				target.sideButton1.visible=false;
				target.sideButton2.visible=false;
				target.centerButton.visible=false;
				return false;
			}
			resetLocation();
			initListener();
			return true;
		}
		private function resetLocation():void
		{
			target.sideButton1.x=target.point1.x;
			target.sideButton1.y=target.point1.y;
			target.sideButton2.x=target.point2.x;
			target.sideButton2.y=target.point2.y;
			target.centerButton.x=(target.point1.x+target.point2.x)/2;
			target.centerButton.y=(target.point1.y+target.point2.y)/2;
		}
		private function initListener():void
		{
			target.sideButton1.addEventListener(MouseEvent.CLICK,onButton1Click);
			target.sideButton2.addEventListener(MouseEvent.CLICK,onButton2Click);
		}
		private function onButton1Click(e:MouseEvent):void
		{
			if(target.textField.scrollV>1)
			{
				target.textField.scrollV-=1;
			}
		}
		private function onButton2Click(e:MouseEvent):void
		{
			if(target.textField.scrollV<target.textField.numLines)
			{
				target.textField.scrollV+=1;
			}
		}
		public function dispose():void
		{
			
		}
	}
}
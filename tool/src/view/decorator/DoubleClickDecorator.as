package  view.decorator
{
	import flash.events.MouseEvent;
	/**
	 * 模拟双击
	 * 只要传入要实现双击的对象就行，但需要双击的对象必须实现IDoubleClickDecorator接口，否则报错
	 * */
	public class DoubleClickDecorator
	{
		private var s:int=0;
		private var ss:Date;
		private var t0:Number;
		private var t1:Number;
		private var t2:Number;
		private var m0:Number;
		private var m1:Number;
		private var m2:Number;
		private var target:*
		public function DoubleClickDecorator(target:*)
		{
			if(target is IDoubleClickDecorator)
			{
				this.target=target;
				target.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}else
			{
				throw new Error("没有实现IDoubleClickDecorator接口");
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
          if(s==0)
          {  
             s=1;  
             ss=new Date();  
             m0=ss.getHours();  
             m1=ss.getMinutes();  
             m2=ss.getSeconds();         //  以上三个，是记录第一次点击的时间的。  
          }else
          {  
             s=0;  
             ss=new Date();  
             t0=ss.getHours();  
             t1=ss.getMinutes();  
             t2=ss.getSeconds();           //以上三个，是记录第二次点击的时间的。  
             if(t0==m0 && t1==m1 && t2==m2)  
             {
             	IDoubleClickDecorator(target).doubleClick();
             }                                    
          }    
		}
		public function dispose():void
		{
			target=null;
			ss=null;
		}
	}
}
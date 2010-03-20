package lxfa.utils.movement
{
	import caurina.transitions.Tweener;
	
	//让物体上下运动的类，speed为运动速度。当物体为空时,这个类自动无效
	public class UpDownMovement
	{
		private var _speed:Number=0;   //运动的速度
		private var obj:*;             //要进行上下运动的对象
		private var maxHeight:Number=0;//上下运动的最高点
		private var minHeight:Number=0;//上下运动的最低点
		private var sourceHeight:Number;
		//obj为要运动的对象
		public function UpDownMovement(obj:*,maxHeight:Number,minHeight:Number,speed:Number=3)
		{
			this.obj=obj;
			this.maxHeight=maxHeight;
			this.minHeight=minHeight;
			this.sourceHeight=obj.y;
			this.speed=speed;
			initMovement();
		}
		//
		private function initMovement():void
		{
			if(obj!=null)
			{
				Tweener.addTween(obj,{y:maxHeight+this.sourceHeight,time:speed,onComplete:moveUpComplete,delay:2});
			}
		}
		//向上运动
		private function moveUpComplete():void
		{
			if(obj!=null)
			{
				Tweener.addTween(obj,{y:this.sourceHeight-minHeight,time:speed,onComplete:moveDownComplete,delay:2});
			}
		}
		//向下运动
		private function moveDownComplete():void
		{
			if(obj!=null)
			{
				Tweener.addTween(obj,{y:maxHeight+this.sourceHeight,time:speed,onComplete:moveUpComplete,delay:2});
			}
		}
		private function set speed(num:Number):void
		{
			_speed=num;
		}
		private function get speed():Number
		{
			return _speed;
		}
	}
}
package lxfa.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MyTimerWithTask extends Sprite
	{
		private var task:Array;
		private var myTimer:MyTimer;
		public function MyTimerWithTask(task:Array)
		{
			this.task=task;
			initMyTimer();
		}
		private function initMyTimer():void
		{
			myTimer=new MyTimer();
			myTimer.startTimer();
			myTimer.addEventListener(Event.CHANGE,on_myTimer_change);
		}
		private function on_myTimer_change(e:Event):void
		{
			if(task!=null && task.length>0)
			{
				if(int(task[0])==myTimer.secondused)
				{
					task.shift();
					this.dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}
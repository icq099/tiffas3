package lxfa.utils{
	//秒间隔计时器
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class MyTimer extends Sprite{
	   private var date:Date=new Date();
	   private var timer:Timer=new Timer(100);
	   private var numA:Number;
	   private var numB:Number;
	   private var nowTime:Number;
	   private var lastTime:Number=0;
	   private var secondUsed:int=-1;//总共过来多少秒
	   public function MyTimer():void {
	    //构造函数空
	   }
	   //公开方法,开始计时
	   public function startTimer():void {
		    numA=date.getTime();
		    if (timer.hasEventListener(TimerEvent.TIMER)==false) {
		     timer.addEventListener(TimerEvent.TIMER,handler);
		     timer.start();
		    }
	   }
	   //公开方法，停止计时
	   public function stopTimer():void {
	    if (timer.hasEventListener(TimerEvent.TIMER)) {
	     timer.removeEventListener(TimerEvent.TIMER,handler);
	    }
	   }
		private function handler(event:TimerEvent):void {
		    numB=new Date().getTime();
		    nowTime=(numB-numA)/1000;
		    if (Math.floor(nowTime)>lastTime) {
		     lastTime=Math.floor(nowTime);
		     secondUsed++;
		     this.dispatchEvent(new Event(Event.CHANGE));//秒数改变了
		   }
	    }
	    public function  get secondused():int{
	    	return secondUsed;
	    }
	}
}
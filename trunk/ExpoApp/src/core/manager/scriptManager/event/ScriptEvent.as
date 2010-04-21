package core.manager.scriptManager.event
{
	import flash.events.Event;

	public class ScriptEvent extends Event
	{
		public static var ADDAPI:String="ScriptEvent.ADDAPI";      //添加API的时候调用
		public static var REMOVEAPI:String="ScriptEvent.REMOVEAPI";//删除API的时候调用
		public static var RUNAPI:String="ScriptEvent.RUNAPI";      //运行API的时候调用
		public static var RUNSCRIPT:String="ScriptEvent.RUNSCRIPT";//运行脚本的时候调用
		public var funName:String;                                 //函数名
		public var fun:Function;                                   //函数
		public var script:String;                                  //脚本名
		public function ScriptEvent(type:String,funName:String,fun:Function=null,script:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.funName=funName;
			this.fun=fun;
			this.script=script;
		}
	}
}
package yzhkof.loader.proxy
{
	import flash.events.IEventDispatcher;
	
/**
* 实现接口时应该将导致loader终止的方法的地方抛出此事件 
*/	
	[Event(name="next_step", type="yzhkof.loader.LoaderEvent")]
	public interface IManageLoader extends IEventDispatcher
	{
		function managePause():void
		function manageStart(value:Object):void
		function manageUnload():void
		function manageResume(value:Object=null):void
		function manageUnloadAndStop(gc:Boolean=true):void
	}
}
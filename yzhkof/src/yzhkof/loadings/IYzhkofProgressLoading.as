package yzhkof.loadings
{
	import flash.events.ProgressEvent;
	
	public interface IYzhkofProgressLoading extends IYzhkofLoading
	{
		function updateByProgressEvent(e:ProgressEvent):void
		function updateByNumber(load_number:Number,total:Number):void
	}
}
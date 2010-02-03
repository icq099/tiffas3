package yzhkof.flow
{
	public interface IFlowModule
	{
		function nextStep():void
		function gotoStepByIndex(index:int):void
	}
}
package yzhkof.debug
{
	import flash.utils.describeType;
	
	public function debugObjectTrace(obj:Object):void
	{
		debugTrace(TextUtil.objToTextTrace(obj));
	}
}
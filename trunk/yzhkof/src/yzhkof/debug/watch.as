package yzhkof.debug
{
	public function watch(obj:Object,property:String,name:String = null):void
	{
		DebugSystem.watchViewer.addWatch(obj,property,name);
	}
}
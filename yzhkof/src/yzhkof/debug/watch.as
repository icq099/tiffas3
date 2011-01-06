package yzhkof.debug
{
	public function watch(obj:Object,property:String,name:String = null):void
	{
		if(DebugSystem.isInited == false) return;
		DebugSystem.watchViewer.addWatch(obj,property,name);
	}
}
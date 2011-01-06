package yzhkof.debug
{
	public function log(obj:*,tag:String = ""):void
	{
		if(DebugSystem.isInited == false) return;
		DebugSystem.logViewer.addLog(obj,tag);
	}
}
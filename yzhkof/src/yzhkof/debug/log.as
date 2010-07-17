package yzhkof.debug
{
	public function log(obj:*,tag:String = ""):void
	{
		DebugSystem.logViewer.addLog(obj,tag);
	}
}
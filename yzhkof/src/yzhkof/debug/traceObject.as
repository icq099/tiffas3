package yzhkof.debug
{
	public function traceObject(obj:Object,showFunctionReturn:Boolean=false):void{
		if(DebugSystem.isInited == false) return;
		trace(TextUtil.objToTextTrace(obj,showFunctionReturn));
	}
}
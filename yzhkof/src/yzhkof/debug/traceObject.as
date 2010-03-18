package yzhkof.debug
{
	public function traceObject(obj:Object,showFunctionReturn:Boolean=false):void{
		trace(TextUtil.objToTextTrace(obj,showFunctionReturn));
	}
}
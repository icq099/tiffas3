package yzhkof.debug
{
	public function debugTrace(...text:Array):void
	{
		for each(var i:Object in text){
			
			try{
				
				TextTrace.textPlus(i.toString()+" ");
				TextTrace.visible = true;
			
			}catch(e:Error){
			
			}
		
		}
		TextTrace.textPlus("\n");
		
	}
}
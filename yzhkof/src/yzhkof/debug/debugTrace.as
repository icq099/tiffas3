package yzhkof.debug
{
	public function debugTrace(...text:Array):void
	{
		for each(var i:Object in text){
			
			try{
				
				TextTrace.textPlus(i.toString()+" ");
			
			}catch(e:Error){
			
			}
		
		}
		TextTrace.textPlus("\n");
		
	}
}
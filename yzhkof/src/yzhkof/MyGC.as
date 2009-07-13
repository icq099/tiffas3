package yzhkof
{
	import flash.net.LocalConnection;
	
	public class MyGC
	{
		public static function gc():void{
			
			try{
				
		        new LocalConnection().connect("a");
		        new LocalConnection().connect("a");
			}catch(erro:Error){
				
			
			}

		
		}

	}
}
package yzhkof.loader
{
	import flash.events.Event;
	
	public class SeriaCompatibleLoader extends SerialLoaderBase
	{
		public function SeriaCompatibleLoader()
		{
			super(CompatibleLoader,"load",null,Event.COMPLETE,"unloadAndStop","content");
		}		
	}
}
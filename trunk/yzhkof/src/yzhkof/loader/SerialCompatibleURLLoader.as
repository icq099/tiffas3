package yzhkof.loader
{
	import flash.events.Event;
	
	public class SerialCompatibleURLLoader extends SerialLoaderBase
	{
		public function SerialCompatibleURLLoader(loadFunction:String="load")
		{
			super(CompatibleURLLoader, loadFunction, null, Event.COMPLETE, null, "data");
		}
		
	}
}
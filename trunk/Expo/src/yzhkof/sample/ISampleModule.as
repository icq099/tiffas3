package yzhkof.sample
{
	import mx.messaging.channels.StreamingAMFChannel;
	
	public interface ISampleModule
	{
		function getSampleName(id:String):String
		function showSample(id:String):void
		function getSamplePictureUrl(id:String):String
	}
}
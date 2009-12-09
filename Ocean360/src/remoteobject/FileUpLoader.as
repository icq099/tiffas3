package remoteobject
{
	import flash.utils.ByteArray;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.remoting.RemoteObject;

	public class FileUpLoader extends RemoteObject
	{
		public function FileUpLoader()
		{
			super("FileUpLoader");
		}
		public function upLoadHotPoint(data:HotPointStruct):AbstractOperation{
			super.upLoadHotPoint(data);
			return super.getOperation("upLoadHotPoint");
		}
		public function saveXml(menuxml:ByteArray,hotpointxml:ByteArray):AbstractOperation{
			super.saveXml(menuxml,hotpointxml);
			return super.getOperation("saveXml");
		}
	}
}
package remoteobject
{
	import flash.utils.ByteArray;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.remoting.mxml.RemoteObject;

	public dynamic class FileUpLoader extends RemoteObject
	{
		public function FileUpLoader()
		{
			super("FileUpLoader");
		}
		public function upLoadHotPointO(data:HotPointStruct):AbstractOperation{
			this.upLoadHotPoint(data);
			return getOperation("upLoadHotPoint");
		}
		public function saveXmlO(menuxml:ByteArray,hotpointxml:ByteArray):AbstractOperation{
			this.saveXml(menuxml,hotpointxml);
			return getOperation("saveXml");
		}
		public function deleteHotPointO(hotpointxml:ByteArray,fileUrl:Array):AbstractOperation{
			this.deleteHotPoint(hotpointxml,fileUrl);
			return getOperation("deleteHotPoint");
		}
	}
}
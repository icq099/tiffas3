package swfguarder
{
	public class SwfGuarderOperation
	{
		public var onComplete:CallBacker = new CallBacker(this);
		public var onProgress:CallBacker = new CallBacker(this);
		public function SwfGuarderOperation()
		{
		}
	}
}
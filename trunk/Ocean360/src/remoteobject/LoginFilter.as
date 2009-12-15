package remoteobject
{
	import mx.events.DynamicEvent;
	import mx.rpc.AbstractOperation;
	import mx.rpc.remoting.RemoteObject;
	
	public dynamic class LoginFilter extends RemoteObject
	{
		public function LoginFilter()
		{
			super("LoginFilter");
		}
		public function sendUserO(name:String,password:String):AbstractOperation{
			this.sendUser(name,password);
			return getOperation("sendUser");			
		}
		public function getSessionO(session_name:String):AbstractOperation{
			this.getSession(session_name);
			return getOperation("getSession");
		}
	}
}
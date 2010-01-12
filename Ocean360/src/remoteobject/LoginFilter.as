package remoteobject
{
	import mx.rpc.AbstractOperation;
	import mx.rpc.remoting.mxml.RemoteObject;
	
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
		public function passwordUpdateO(name:String,password:String,newpassword:String,passwordagain:String):AbstractOperation{
			this.passwordUpdate(name,password,newpassword,passwordagain);
			return getOperation("passwordUpdate");
		}
	}
}
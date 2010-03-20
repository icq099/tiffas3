package lsd.ZongHengSiHai
{
	public class ZongHengSiHaiStatic
	{
		private static var instance:ZongHengSiHaiStatic;
		public var currentModuleName:String;
		public function ZongHengSiHaiStatic()
		{
			if(instance==null){
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():ZongHengSiHaiStatic{
			if(instance==null) instance=new ZongHengSiHaiStatic();
			return instance;
		}
	}
}
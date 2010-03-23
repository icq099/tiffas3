package lxfa.yangmengbagui
{
	public class YangMengBaGuiStatic
	{
		private static var instance:YangMengBaGuiStatic;
		public var currentModuleName:String;
		public function YangMengBaGuiStatic()
		{
			if(instance==null){
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():YangMengBaGuiStatic{
			if(instance==null) instance=new YangMengBaGuiStatic();
			return instance;
		}
	}
}
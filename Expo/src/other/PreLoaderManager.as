package other
{
	public class PreLoaderManager
	{
		private static var _instance:PreLoaderManager;
		public static const PICTURE_LOAD_RANK:int=0;
		public static const PRELOAD_RANK:int=1;
		
		private var xml:XML;
		public function PreLoaderManager()
		{
			if(_instance!=null){
				throw new Error("无法实例化！");
			}
		}
		public static function getInstance():PreLoaderManager{
			if(_instance==null){
				_instance=new PreLoaderManager();
			}
			return _instance;
		}
		public function init(xml:XML):void{
			this.xml=xml;
		}

	}
}
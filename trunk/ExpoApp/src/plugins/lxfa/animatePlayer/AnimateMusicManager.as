package plugins.lxfa.animatePlayer
{
	import util.MusicBase;
	
	public class AnimateMusicManager extends MusicBase
	{
		private static var _instance:AnimateMusicManager;
		public function AnimateMusicManager()
		{
			if(_instance==null)
			{
				_instance=this;
			}else
			{
				throw new Error("AnimateMusicManager不能被初始化!");
			}
		}
		public static function getInstance():AnimateMusicManager
		{
			if(_instance==null) return new AnimateMusicManager();
			return _instance;
		}
	}
}
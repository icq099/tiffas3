package lxfa.customMusic
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class CustomMusicManager
	{
		private static var instance:CustomMusicManager
		private var isLoop:Boolean=false;
		private var soundUrl:String;
		private var loader:Loader;
		private var hasCustomMusic:Boolean;
		public function CustomMusicManager()
		{
			if(instance==null){
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		public static function getInstance():CustomMusicManager{
			if(instance==null) instance=new CustomMusicManager();
			return instance;
		}
		//loop为true，表示要循环
		public function loadUrl(url:String,loop:Boolean=false):void
		{
			loader=new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,on_sound_complete);
		}
		private function on_sound_complete(e:Event):void
		{
			MovieClip(loader.content).play();
			hasCustomMusic=true;
		}
		public function stop():void
		{
			if(hasCustomMusic && loader!=null)
			{
				if(MovieClip(loader.content)!=null)
				{
					loader=null;
				}
			}
		}
		public function close():void
		{
			stop();
		}
		public function play():void
		{
			if(hasCustomMusic && loader!=null)
			{
				if(MovieClip(loader.content)!=null)
				{
					MovieClip(loader.content).play();
				}
			}
		}
	}
}
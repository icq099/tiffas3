package plugins.lxfa.animatePlayer.model
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	
	public class AnimatePlayerModel
	{
		private var xmlData:XML;
		private static var _instance:AnimatePlayerModel;
		private var texts:Array=new Array();
		private var music:String="";
		private var _hasText:int;
		public function AnimatePlayerModel()
		{
			if(_instance==null)
			{
				this.xmlData=ModelManager.getInstance().xmlAnimate;
				_instance=this;
			}else
			{
				throw new Error("AnimatePlayerModel不能被实例化");
			}
		}
		public static function getInstance():AnimatePlayerModel
		{
			if(_instance==null) return new AnimatePlayerModel;
			return _instance;
		}
		/**
		 * 读取声音,文本和相关的时间
		 */ 
		public function init(id:int):void
		{
			var currentXml:XML=xmlData.Animate[id];
			_hasText=currentXml.@hasText;
			if(MainSystem.getInstance().language==MainSystem.CHINESE)
			{
				music=currentXml.Chinese.@music;
				for(var i:int=0;i<currentXml.Chinese.Task.length();i++)
				{
					texts.push({time:currentXml.Chinese.Task[i].@time,script:currentXml.Chinese.Task[i].@script});
				}
			}else
			{
				music=currentXml.English.@music;
				for(i=0;i<currentXml.English.Task.length();i++)
				{
					texts.push({time:currentXml.English.Text[i].@time,script:currentXml.English.Text[i].@script});
				}
			}
		}
		/**
		 * 获取文本的显示情况
		 */ 
		public function get hasText():Boolean
		{
			if(_hasText==1)
			{
				return true;
			}
			return false;
		}
		/**
		 * 获取音乐的路径
		 */ 
		public function get musicUrl():String
		{
			return music;
		}
		/**
		 * 返回最近要显示的文本，并删除该文本
		 */ 
		public function getNearestTask():Object
		{
			return this.texts.shift();
		}
		/**
		 * 最近要显示文字的时间
		 */ 
		public function getNearestTime():int
		{
			if(this.textsLength>0)
			{
				return int(texts[0].time);
			}
			return -1;
		}
		/**
		 * 还剩下多少文字
		 */ 
		public function get textsLength():int
		{
			return texts.length;
		}
		/**
		 * 清空内存
		 */ 
		public function dispose():void
		{
			texts=new Array();
		}
	}
}
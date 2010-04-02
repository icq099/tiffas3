package lxfa.model
{
	public class BackGroundMusicModel extends XmlLoaderModel
	{
		public function BackGroundMusicModel()
		{
			super("xml/basic.xml");
		}
		public function getMusicUrl(id:int):String{
			if (id>xmlData.Travel.Scene.length() || (xmlData.Travel.Scene[id].@backGroundMusic == "" || xmlData.Travel.Scene[id].@backGroundMusic == null))
			{
				return null;
			}
			return xmlData.Travel.Scene[id].@backGroundMusic;
		}
		override public function dispose():void{
		}
	}
}
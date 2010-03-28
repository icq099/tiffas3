package lxfa.model
{
	public class BackGroundMusicModel extends XmlLoaderModel
	{
		public function BackGroundMusicModel()
		{
			super("xml/basic.xml");
		}
		public function getMusicUrl(id:int):String{
			return xmlData.Travel.Scene[id].@backGroundMusic;
		}
		override public function dispose():void{
		}
	}
}
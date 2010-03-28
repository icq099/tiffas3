package lxfa.model
{
	public class CustomMusicModel extends XmlLoaderModel
	{
		public function CustomMusicModel()
		{
			super("xml/basic.xml");
		}
		public function getMusicUrl(id:int):String{
			return xmlData.Travel.Scene[id].@customMusic;
		}
		override public function dispose():void{
		}
	}
}
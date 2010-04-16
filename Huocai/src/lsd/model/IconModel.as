package lsd.model
{
	public class IconModel extends XmlLoaderModel
	{
		public function IconModel()
		{
			super("xml/huocai.xml")
		}
		
		
		public function getIconXML():XMLList{
			
			return XMLList(xmlData.icons.icon);
		}
		
		public function getEffect(id:String):String{
			
			return xmlData.icons.icon[id].@effect;
		}


	}
}
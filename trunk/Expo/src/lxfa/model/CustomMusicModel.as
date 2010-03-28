package lxfa.model
{
	public class CustomMusicModel extends XmlLoaderModel
	{
		public function CustomMusicModel()
		{
			super("xml/basic.xml");
		}
		public function getMusicUrl(id:int):String{
		   if(xmlData.Travel.Scene[id]!=null){
			 
			  return xmlData.Travel.Scene[id].@customMusic;
		   }
		   else{
		          return null;
		     }
		  }
		  override public function dispose():void{
		  
		  }
	}
}
package lxfa.gehaiqingyun.model
{
	import lxfa.model.XmlLoaderModel;
	
	public class GeHaiQingYunModel extends XmlLoaderModel
	{
		public function GeHaiQingYunModel(path:String)
		{
			super(path);
		}
		public function getMediaList():Array
		{
			var i:int;
			var mediaList:Array=new Array();
			for(i=0;i<xmlData.Media.length();i++)
			{
				mediaList.push(xmlData.Media[i]);
			}
			return mediaList;
		}
		public function getMediaNames():Array
		{
			var i:int=0;
			var mediaNames:Array=new Array();
			for(i=0;i<xmlData.Media.length();i++)
			{
				mediaNames.push(xmlData.Media[i].@name);
			}
			return mediaNames;
		}
	}
}
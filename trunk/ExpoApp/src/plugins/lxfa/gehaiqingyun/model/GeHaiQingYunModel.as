package plugins.lxfa.gehaiqingyun.model
{
	import core.manager.modelManager.ModelManager;
	
	public class GeHaiQingYunModel
	{
		private var xmlData:XML
		public function GeHaiQingYunModel()
		{
			xmlData=ModelManager.getInstance().xmlGehaiqingyun;
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
		public function dispose():void
		{
			xmlData=null;
		}
	}
}
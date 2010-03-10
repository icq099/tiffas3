package lxfa.animation.model
{
	import lxfa.model.XmlLoaderModel;
	
	public class GuiWaTextModel extends XmlLoaderModel
	{
		public function GuiWaTextModel(path:String)
		{
			super(path);
		}
		public function getMp3Path(num:int):String
		{
			return xmlData.LRCText[num].@mp3;
		}
		public function getTexts(num:int):Array
		{
			var i:int=0;
			var length:int=xmlData.LRCText[num].Text.length();
			var texts:Array=new Array();
			for(i=0;i<length;i++)
			{
				texts.push(xmlData.LRCText[num].Text[i]);
			}
			return texts;
		}
		public function getTimes(num:int):Array
		{
			var i:int=0;
			var length:int=xmlData.LRCText[num].Text.length();
			var times:Array=new Array();
			for(i=0;i<length;i++)
			{
				times.push(xmlData.LRCText[num].Text[i].@time);
			}
			return times;
		}
	}
}
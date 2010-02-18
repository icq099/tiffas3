package lxfa.shanshuishihua.model
{
	import lxfa.model.ItemModel;
	
	public class ShanShuiShiHuaModel extends ItemModel
	{
		public function ShanShuiShiHuaModel()
		{
			super();
		}
		public function getXmlData():XML
		{
			return xmlData;
		}
		public function getPictureList():Array
		{
			return null;
		}
		public function getImgUrl(num:int):String
		{
			return xmlData.shanshuishihua.Item[num].@image;
		}
		//获取指定位置的图片
		public function getPictureUrl(num:int):String
		{
			return xmlData.shanshuishihua.Item[num].Picture[0];
		}
		public function getItemOfNumber():int
		{
			return xmlData.shanshuishihua.Item.length();//Item的长度
		}
		public function getVideoUrl(num:int):String
		{
			return xmlData.shanshuishihua.Item[num].Video[0];
		}
		public function getText(num:int):String
		{
			return xmlData.shanshuishihua.Item[num].Text[0];
		}
		public function getSoundUrl(num:int):String
		{
			return xmlData.shanshuishihua.Item[num].Sound[0];
		}
	}
}
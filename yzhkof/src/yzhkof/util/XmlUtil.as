package yzhkof.util
{
	public class XmlUtil
	{
		public function XmlUtil()
		{
		}
		public static function deleteXmlList(xml_list:XMLList):void{
			var length:int=xml_list.length();
			for(var i:int=0;i<length;i++){
				delete xml_list[0];
			}
		}
	}
}
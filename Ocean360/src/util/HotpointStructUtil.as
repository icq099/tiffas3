package util
{
	import remoteobject.HotPointStruct;
	
	public class HotpointStructUtil
	{
		public static function trans(xml:XML,hotpoint:HotPointStruct,name:String):HotPointStruct{
			var new_xml:XML=new XML("<HotPoint/>");
			var id:String=String(re_xml.HotPoint.length());
			new_xml.@id=id;
			new_xml.@texturl="points/"+hotpoint.textName;
			new_xml.@sound="points/"+hotpoint.soundName;
			new_xml.@name=name;
			new_xml.@swfWidth=700;
			new_xml.@swfHeight=500;
			if(hotpoint.image!=null){
				var image_xml:XML=new XML("<ExhibitInstruction/>");
				var t_xml:XML;
				for(var i:int=0;i<hotpoint.image.length;i++){
					t_xml=new XML("<Img/>");
					t_xml.@url="points/"+hotpoint.imageName;
					image_xml.appendChild(t_xml);	
				}
				new_xml.appendChild(image_xml);
			}
			xml.appendChild(new_xml);
			hotpoint.xml=xml;
			return hotpoint;
		}
	}
}
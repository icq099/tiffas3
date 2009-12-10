package util
{
	import flash.utils.ByteArray;
	
	import remoteobject.HotPointStruct;
	
	public class HotpointStructUtil
	{
		public static function trans(xml:XML,hotpoint:HotPointStruct,name:String):HotPointStruct{
			var date:Date=new Date();
			hotpoint.textName=String(date.getTime()+Math.random()+hotpoint.text.length);
			if(hotpoint.image!=null){
				for(var i:int=0;i<hotpoint.image.length;i++){
					hotpoint.imageName[i]=String(date.getTime()+Math.random()+hotpoint.image[0].length);
				}
			}
			if(hotpoint.sound!=null){
				hotpoint.soundName=String(date.getTime()+Math.random()+hotpoint.sound.length);
			}
			var new_xml:XML=new XML("<HotPoint/>");
			var id:String=String(xml.HotPoint.length());
			var xml_byte:ByteArray=new ByteArray();
			new_xml.@id=id;
			new_xml.@texturl="points/"+hotpoint.textName;
			new_xml.@sound="points/"+hotpoint.soundName;
			new_xml.@name=name;
			new_xml.@swfWidth=700;
			new_xml.@swfHeight=500;
			if(hotpoint.image!=null){
				if(hotpoint.image.length>0){
					var image_xml:XML=new XML("<ExhibitInstruction/>");
					var t_xml:XML;
					for(i=0;i<hotpoint.image.length;i++){
						t_xml=new XML("<Img/>");
						t_xml.@url="points/"+hotpoint.imageName[i];
						image_xml.appendChild(t_xml);	
					}
					new_xml.appendChild(image_xml);
				}
			}
			if(xml.length()<=0){
				xml=new XML("<HotPoints></HotPoints>");
			}
			xml.appendChild(new_xml);
			xml_byte.writeUTFBytes(xml.toString())
			hotpoint.xml=xml_byte;			
			return hotpoint;
		}
	}
}
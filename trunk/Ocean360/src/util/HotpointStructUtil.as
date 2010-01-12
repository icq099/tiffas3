package util
{
	import flash.utils.ByteArray;
	
	import remoteobject.HotPointStruct;
	
	public class HotpointStructUtil
	{
		public static function trans(xml:XML,hotpoint:HotPointStruct,name:String):HotPointStruct{
			var date:Date=new Date();
			hotpoint.textName=new String()+date.getTime()+hotpoint.text.length+int(Math.random()*100);
			if(hotpoint.image!=null){
				for(var i:int=0;i<hotpoint.image.length;i++){
					hotpoint.imageName[i]=new String()+date.getTime()+hotpoint.image[0].length+int(Math.random()*100);
				}
			}
			var new_xml:XML=new XML("<HotPoint/>");
			if(hotpoint.sound!=null){
				hotpoint.soundName=new String()+date.getTime()+hotpoint.sound.length+int(Math.random()*100);
				new_xml.@sound="points/"+hotpoint.soundName;
			}
			if(hotpoint.video!=null){
				hotpoint.videoName=new String()+date.getTime()+hotpoint.video.length+int(Math.random()*100);
				var video_xml:XML=new XML("<ExhibitVideo/>");
				video_xml.@url="points/"+hotpoint.videoName;
				new_xml.appendChild(video_xml);
			}
			var id:String;
			var xml_byte:ByteArray=new ByteArray();
			if(xml.HotPoint.length()<=0){
				id="0";
				xml=new XML("<HotPoints></HotPoints>");
			}else{
				id=String(int(xml.HotPoint[xml.HotPoint.length()-1].@id)+1);
			}
			new_xml.@id=id;
			new_xml.@texturl="points/"+hotpoint.textName;
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
			
			xml.appendChild(new_xml);
			xml_byte.writeUTFBytes(xml.toString())
			hotpoint.xml=xml_byte;			
			return hotpoint;
		}
	}
}
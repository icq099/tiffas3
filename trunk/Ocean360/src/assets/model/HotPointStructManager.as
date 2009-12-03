package assets.model
{
	import flash.utils.ByteArray;
	
	import mx.core.Application;
	import mx.rpc.events.ResultEvent;
	
	import remoteobject.HotPointStruct;
	
	public class HotPointStructManager
	{
		private var hps:HotPointStruct=new HotPointStruct();
		public function HotPointStructManager()
		{
			hps.image=new Array();
			hps.imageName=new Array();
			hps.soundName="";
			hps.sound=new ByteArray();
			hps.textName="";
			hps.text=new ByteArray();
		}
		public function addImageByName(name:String,data:ByteArray):void
		{
			hps.imageName.push(name);
			hps.image.push(data);
		}
		public function deleteImageByName(name:String):void
		{
			for(var i:int=0;i<hps.imageName.length;i++)
			{
				if(hps.imageName[i]==name)
				{
					hps.imageName.splice(i,i);
					hps.image.splice(i,i);
				}
			}
		}
		public function setSound(name:String,data:ByteArray):void
		{
			hps.soundName=name;
			hps.sound=data;
		}
		public function setTextName(name:String):void
		{
			hps.textName=name;
		}
		public function setText(text:String):void
		{
			var temp:ByteArray=new ByteArray();
			temp.writeUTFBytes(text);
			hps.text=temp;
		}
		public function startToUpdate():void
		{
			var by:ByteArray=new ByteArray();
			by.writeUTFBytes("fuckfsadfasdf")
			hps.xml=by;
			Application.application.fileup.upLoadHotPoint(hps);
			Application.application.fileup.addEventListener(ResultEvent.RESULT,function():void{
				Application.application.startUpdateButton.enabled=true;
			});
		}
	}
}
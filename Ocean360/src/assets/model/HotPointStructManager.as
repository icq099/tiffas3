package assets.model
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import remoteobject.FileUpLoader;
	import remoteobject.HotPointStruct;
	
	import util.HotpointStructUtil;
	
//	import util.HotpointStructUtil;
	
	public class HotPointStructManager extends Sprite
	{
		private var hps:HotPointStruct;
		private var sp:SamplePanelBackGround;
		public function HotPointStructManager(sp:SamplePanelBackGround,hps:HotPointStruct)
		{
			this.sp=sp;
			this.hps=hps;
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
		private	var XML_URL:String = "xml/hotpoints.xml";
		private	var urlRequest:URLRequest = new URLRequest(XML_URL); 
		private	var myLoader:URLLoader = new URLLoader(); 
		public function startToUpdate():void
		{
			myLoader.addEventListener(Event.COMPLETE,xmlLoaded);
			myLoader.load(urlRequest);
		}
		private function xmlLoaded(e:Event):void
		{
			this.sp.panel2.errorMsg.text="";
			var xml:XML=XML(myLoader.data);
			var fileup:FileUpLoader=new FileUpLoader();
			fileup.upLoadHotPoint(HotpointStructUtil.trans(xml,hps,this.sp.panel1.title.text));
			fileup.addEventListener(ResultEvent.RESULT,function():void{
				this.sp.panel2.update.enabled=true;
				this.dispatchEvent(new Event(Event.COMPLETE));
			});
			fileup.addEventListener(FaultEvent.FAULT,function():void{
				this.sp.panel2.errorMsg.text="上传失败!";
				this.dispatchEvent(new Event(Event.COMPLETE));
			});
		}
	}
}
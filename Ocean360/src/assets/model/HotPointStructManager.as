package assets.model
{
	import assets.ErrorView;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AbstractOperation;
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
		private var samplepanel:SamplePanel;
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
		public function deleteImageByName(name:String,id:int):void
		{
			for(var i:int=0;i<hps.imageName.length;i++)
			{
				if(hps.imageName[i]==name)
				{
					hps.imageName.splice(i,1);
					hps.image.splice(i,1);
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
			if(sp.panel1.title.text!=null)//如果标题不为空
			{
				myLoader.addEventListener(Event.COMPLETE,xmlLoaded);
				myLoader.load(urlRequest);
			}
			else
			{
				var errorView:ErrorView=PopUpManager.createPopUp(DisplayObject(Application.application),ErrorView,true) as ErrorView;
				PopUpManager.centerPopUp(errorView);
			}
		}
		private function xmlLoaded(e:Event):void
		{
			this.sp.panel2.errorMsg.text="";
			var xml:XML=XML(myLoader.data);
			var fileup:FileUpLoader=new FileUpLoader();
			var dispather:AbstractOperation;
			dispather=fileup.upLoadHotPointO(HotpointStructUtil.trans(xml,hps,this.sp.panel1.title.text));
			dispather.addEventListener(ResultEvent.RESULT,RESULT);
			dispather.addEventListener(FaultEvent.FAULT,FAULT);
		}
		private function RESULT(e:Event):void
		{
			sp.panel2.update.enabled=true;
			this.parent.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function FAULT(e:Event):void
		{
			sp.panel2.errorMsg.text="上传失败!";
			sp.panel2.update.enabled=true;
		}
	}
}
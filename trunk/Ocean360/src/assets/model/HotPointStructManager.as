package assets.model
{
	import assets.ErrorView;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import model.MXml;
	
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
			hps.sound=new ByteArray();
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
		private var errorView:ErrorView;
		public function startToUpdate():void
		{
			if(sp.panel1.title.text!="" && sp.panel1.detail.text!="")//如果标题不为空
			{
				this.sp.panel2.errorMsg.text="";
				var fileup:FileUpLoader=new FileUpLoader();
				var dispather:AbstractOperation;
				dispather=fileup.upLoadHotPointO(HotpointStructUtil.trans(MXml.getInstance().xml_hotpoint,hps,this.sp.panel1.title.text));
				dispather.addEventListener(ResultEvent.RESULT,RESULT);
				dispather.addEventListener(FaultEvent.FAULT,FAULT);
			}
			else
			{
				errorView=PopUpManager.createPopUp(DisplayObject(Application.application),ErrorView,true) as ErrorView;
				errorView.width=400;
				errorView.height=300;
				errorView.errorMsg.text="标题或详细描述不能为空！";
				PopUpManager.centerPopUp(errorView);
				errorView.ok.addEventListener(MouseEvent.CLICK,errorViewClose);
			}
		}
		private function errorViewClose(e:MouseEvent):void
		{
			PopUpManager.removePopUp(errorView);
			sp.panel2.update.enabled=true;
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
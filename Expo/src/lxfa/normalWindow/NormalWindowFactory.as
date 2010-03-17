package lxfa.normalWindow
{
	/****************************
	 * 根据	ID参建标准窗
	 * */
	import flash.events.Event;
	
	import lxfa.shanshuishihua.model.ShanShuiShiHuaModel;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class NormalWindowFactory extends UIComponent
	{
		private var itemModel:ShanShuiShiHuaModel;
		private var ID:int;                        //Item的ID号
		private var picture360Url:String;          //360图片路径
		private var videoUrl:String;               //视频路径
		private var pictureUrls:Array;             //图片路径
		private var picture360Name:String;         //360图片的名字
		private var videoName:String;              //视频的名字
		private var pictureName:String;            //图片的名字
		private var text:String;                   //文本
		private var normalWindow:NormalWindow;
		public function NormalWindowFactory(ID:int)
		{
			this.ID=ID;
			initItemModel();
		}
		//加载数据库
		private function initItemModel():void
		{
			itemModel=new ShanShuiShiHuaModel();
			itemModel.addEventListener(Event.COMPLETE,onComplete);
		}
		//数据库加载完毕
		private function onComplete(e:Event):void
		{
			this.pictureUrls=new Array();
			this.pictureUrls=itemModel.getPictureUrls(ID);
			this.picture360Url=itemModel.getPicture360Url(ID);
			this.videoUrl=itemModel.getVideoUrl(ID);
			this.text=itemModel.getText(ID);
			this.picture360Name=itemModel.getPicture360Name(ID);
			this.pictureName=itemModel.getPictureName(ID);
			this.videoName=itemModel.getVideoName(ID);
			normalWindow=new NormalWindow(picture360Url,videoUrl,pictureUrls,text,picture360Name,videoName,pictureName);
			this.addChild(normalWindow);
			normalWindow.addEventListener(Event.CLOSE,onnormalWindowClose);
			this.dispatchEvent(e);
		}
		//标准窗关闭的时候
		private function onnormalWindowClose(e:Event):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
			normalWindow=null;
			PopUpManager.removePopUp(this);
//			MainSystem.getInstance().removePluginById("NormalWindowModule");
		}
	}
}
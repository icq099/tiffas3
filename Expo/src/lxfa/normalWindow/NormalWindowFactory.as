package lxfa.normalWindow
{
	/****************************
	 * 根据	ID参建标准窗
	 * */
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import lxfa.normalWindow.model.NormalWindowModel;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.modules.ModuleLoader;
	
	public class NormalWindowFactory extends UIComponent
	{
		private var itemModel:NormalWindowModel;
		private var ID:int;                        //Item的ID号
		private var picture360Url:String;          //360图片路径
		private var videoUrl:String;               //视频路径
		private var pictureUrls:Array;             //图片路径
		private var picture360Name:String;         //360图片的名字
		private var videoName:String;              //视频的名字
		private var pictureName:String;            //图片的名字
		private var text:String;                   //文本
		private var animateId:int;                 //桂娃的ID，-1就是没桂娃
		private var animate:DisplayObject          //桂娃
		private var animateParent:ModuleLoader;    //桂娃的父亲容器
		private var normalWindow:NormalWindow;
		public function NormalWindowFactory(ID:int)
		{
			this.ID=ID;
			initItemModel();
		}
		//加载数据库
		private function initItemModel():void
		{
			itemModel=new NormalWindowModel();
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
			this.animateId=itemModel.getAnimateId(ID);
			normalWindow=new NormalWindow(picture360Url,videoUrl,pictureUrls,text,picture360Name,videoName,pictureName);
			this.addChild(normalWindow);
			createAnimate(animateId);
			normalWindow.addEventListener(Event.CLOSE,onnormalWindowClose);
			this.dispatchEvent(e);
		}
		private function createAnimate(animateId:int):void
		{
			//显示桂娃
			if(animateId!=-1)
			{
		        MainSystem.getInstance().runAPIDirect("addAnimate",[animateId]);
		        animate=MainSystem.getInstance().getPlugin("AnimateModule");
		        animateParent=ModuleLoader(animate.parent);
		        animate.x=-20;
		        animate.y=300;
			    this.addChild(animate);
			}
		}
		//标准窗关闭的时候
		private function onnormalWindowClose(e:Event):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
			normalWindow=null;
			PopUpManager.removePopUp(this);
			if(MainSystem.getInstance().isBusy==true)
			{
				MainSystem.getInstance().isBusy=false;
				MainSystem.getInstance().runAPIDirect("removeAnimate",[]);
				MainSystem.getInstance().isBusy=true;
			}else
			{
				MainSystem.getInstance().runAPIDirect("removeAnimate",[]);
			}
			animateParent.addChild(animate);
		}
	}
}
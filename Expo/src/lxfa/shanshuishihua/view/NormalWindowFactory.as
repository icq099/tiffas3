package lxfa.shanshuishihua.view
{
	/****************************
	 * 根据	ID参建标准窗
	 * */
	import flash.events.Event;
	
	import lxfa.shanshuishihua.model.ItemModel;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class NormalWindowFactory extends UIComponent
	{
		private var itemModel:ItemModel;
		private var ID:int;//Item的ID号
		private var pictureUrl:String;//图片路径
		private var videoUrl:String;//视频路径
		private var musicUrl:String;//音频路径
		private var text:String;//文本
		private var normalWindow:NormalWindow;
		public function NormalWindowFactory(ID:int)
		{
			this.ID=ID;
			initItemModel();
		}
		//加载数据库
		private function initItemModel():void
		{
			itemModel=new ItemModel();
			itemModel.addEventListener(Event.COMPLETE,onComplete);
		}
		//数据库加载完毕
		private function onComplete(e:Event):void
		{
			pictureUrl=itemModel.getPictureUrl(ID);
			videoUrl=itemModel.getVideoUrl(ID);
			musicUrl=itemModel.getSoundUrl(ID);
			text=itemModel.getText(ID);
			normalWindow=new NormalWindow(pictureUrl,videoUrl,musicUrl,text);
			this.addChild(normalWindow);
			normalWindow.addEventListener(Event.CLOSE,onnormalWindowClose);
			this.dispatchEvent(e);
		}
		//标准窗关闭的时候
		private function onnormalWindowClose(e:Event):void
		{
			PopUpManager.removePopUp(this);
		}
	}
}
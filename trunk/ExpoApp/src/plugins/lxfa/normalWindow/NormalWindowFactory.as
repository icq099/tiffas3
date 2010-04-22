package plugins.lxfa.normalWindow
{
	/****************************
	 * 根据	ID参建标准窗
	 * */
	import core.manager.MainSystem;
	import core.manager.musicManager.BackGroundMusicManager;
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import memory.MemoryRecovery;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.modules.ModuleLoader;
	
	import plugins.lxfa.normalWindow.event.NormalWindowEvent;
	import plugins.model.ItemModel;
	
	public class NormalWindowFactory extends UIComponent
	{
		private var itemModel:ItemModel;
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
		private var animateParent:Canvas;    //桂娃的父亲容器
		private var normalWindow:NormalWindow;
		public function NormalWindowFactory(ID:int)
		{
			BackGroundMusicManager.getInstance().dispose();
			this.ID=ID;
			initItemModel();
		}
		//加载数据库
		private function initItemModel():void
		{
			itemModel=new ItemModel();
			onComplete();
		}
		//数据库加载完毕
		private function onComplete():void
		{
			MainSystem.getInstance().dispatchEvent(new NormalWindowEvent(NormalWindowEvent.SHOW));
			createWindow(null);
		}
		private function createWindow(e:Event):void
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
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function createAnimate(animateId:int):void
		{
			//显示桂娃
			if(animateId!=-1)
			{
		        ScriptManager.getInstance().runScriptByName(ScriptName.ADDANIMATE,[animateId]);
		        animate=PluginManager.getInstance().getPlugin("AnimateModule");
		        animateParent=Canvas(animate.parent);
		        animate.x=-20;
		        animate.y=300;
			    this.addChild(animate);
			}
		}
		//标准窗关闭的时候
		private function onnormalWindowClose(e:Event):void
		{
			if(!MainSystem.getInstance().isBusy)
			{
				MainSystem.getInstance().dispatchEvent(new NormalWindowEvent(NormalWindowEvent.REMOVE));
				MemoryRecovery.getInstance().gcFun(e.currentTarget,Event.CLOSE,onnormalWindowClose);
				BackGroundMusicManager.getInstance().reload();
				ScriptManager.getInstance().runScriptByName(ScriptName.STOPRENDER,[]);
				this.dispatchEvent(new Event(Event.CLOSE));
				normalWindow=null;
				if(animate!=null)
				{
					animateParent.addChild(animate);
				}
				PopUpManager.removePopUp(this);
				ScriptManager.getInstance().runScriptByName(ScriptName.REMOVEANIMATE,[]);
			}
		}
	}
}
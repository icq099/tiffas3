package lxfa.normalWindow
{
	/****************************
	 * 根据	ID参建标准窗
	 * */
	import communication.Event.ScriptAPIAddEvent;
	import communication.MainSystem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import lxfa.normalWindow.model.NormalWindowModel;
	import lxfa.utils.CollisionManager;
	
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
		private var type:String;                   //类型
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
			type=itemModel.getType(ID);
			if(type=="" || type==null)
			{
				createWindow(e);
			}else if(type=="ShanShuiShiHuaModule")
			{
				create("ShanShuiShiHuaModule","getShanShuiShiHua",10,20);
			}
			else if(type=="LiJiangWanChangModule")
			{
				create("LiJiangWanChangModule","getLiJiangWanCHang",10,20);
			}
			else if(type=="MinZuBaiMeiModule")
			{
				create("MinZuBaiMeiModule","getMinZuBaiMei",10,20);
			}
			else if(type=="GeHaiQingYunModule")
			{
				create("GeHaiQingYunModule","getGeHaiQingYun",10,20);
			}
			else if(type=="ChengShiGuangYingModule")
			{
				createChengShiGuangYing();
			}
		}
		private function createChengShiGuangYing():void
		{
			MainSystem.getInstance().showPluginById("ChengShiGuangYingModule");
			MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.ADD_API,function(e:ScriptAPIAddEvent):void{
				if(e.fun_name=="initChengShiGuangYing")
				{
					MainSystem.getInstance().runAPIDirectDirectly("initChengShiGuangYing",[ID]);
					var dis:DisplayObject=MainSystem.getInstance().getPlugin("ChengShiGuangYingModule");
					dis.addEventListener(Event.COMPLETE,on_chengshiguangying_complete);
				}
			});
		}
		private function on_chengshiguangying_complete(e:Event):void
		{
			this.addChild(MainSystem.getInstance().runAPIDirectDirectly("getChengShiGuangYing",[]));
		}
		private function create(moduleName:String,funName:String,x:int,y:int):void
		{
			MainSystem.getInstance().showPluginById(moduleName);
			MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.ADD_API,function(e:ScriptAPIAddEvent):void{
				if(e.fun_name==funName)
				{
					var dis:DisplayObject=MainSystem.getInstance().runAPIDirectDirectly(funName,[]);
					dis.x=x;
					dis.y=y;
					dis.addEventListener(Event.CLOSE,onnormalWindowClose);
					addChild(dis);
				}
			});
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
			MainSystem.getInstance().startRender();
			this.dispatchEvent(new Event(Event.CLOSE));
			normalWindow=null;
			if(animate!=null)
			{
				animateParent.addChild(animate);
			}
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
		}
	}
}
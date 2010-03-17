package lxfa.animation.view
{
	import caurina.transitions.Tweener;
	
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.animation.model.GuiWaTextModel;
	import lxfa.utils.MyTimerWithTask;
	import lxfa.view.event.Mp3PlayerEvent;
	import lxfa.view.player.Mp3Player;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class AnimationBase  extends UIComponent
	{
		private var animationIn:AnimationIn;//进场动画
		private var animationText:SayText;//说话的文本
		private var animationSay:AnimationSay;//说话的动画
		private var animationOut:AnimationOut;//退场的动画
		private var animationClose:AnimationClose;//桂娃的关闭按钮
		private var guiWaTextModel:GuiWaTextModel;//数据库
		private var myTimerWithTask:MyTimerWithTask;
		private var texts:Array=new Array;
		private var times:Array=new Array();
		private var mp3Path:String;
		private var ID:int;
		private var mp3Player:Mp3Player;//说话的内容
		private var guiWaTextPath:String="xml/GuiWaText.xml";//model的路径
		private const xOffset:int=680;//X偏移量,用于调整整个桂娃的位置，毕竟桂娃的组件很多,可以一次性调
		private const yOffset:int=300;
		private var guiwaContainer:UIComponent;//桂娃的容器,桂娃的所有部件都在这
		private var willPop:Boolean=false;//是否需要POP出来
		private var inquireSwc:InquireSwc;
		private var open:Boolean=false;//是否开启下一个场景
		private var isClosing:Boolean=false;//桂娃是否处于关闭状态
		public function AnimationBase()
		{
			MainSystem.getInstance().addAPI("showGuiWa",initGuiWaTextModel);
			MainSystem.getInstance().addAPI("removeGuiWa",getOut);
//			MainSystem.getInstance().runAPIDirect("showGuiWa",[2,true]);
		}
		public function initGuiWaTextModel(ID:int,willPop:Boolean=false):UIComponent
		{
			guiwaContainer=new UIComponent();//初始化桂娃存储的容器
			open=false;//默认不开启下一个场景
			isClosing=false;
			this.ID=ID;
			this.willPop=willPop;
			guiWaTextModel=new GuiWaTextModel(guiWaTextPath);
			guiWaTextModel.addEventListener(Event.COMPLETE,onModelComplete);
			addCloseButton();
			return guiwaContainer;
		}
		private function addCloseButton():void
		{
			animationClose=new AnimationClose();
			guiwaContainer.addChild(animationClose);
			animationClose.x=200+xOffset;
			animationClose.y=0+yOffset;
			animationClose.alpha=0;
			animationClose.addEventListener(MouseEvent.CLICK,onCloseButtonClick);
		}
		private function onCloseButtonClick(e:MouseEvent):void
		{
			animationClose.mouseEnabled=false;
			dispatchEvent(new Event(Event.CLOSE));
			getOut();
		}
		private function onModelComplete(e:Event):void
		{
			this.times=guiWaTextModel.getTimes(this.ID);
			this.texts=guiWaTextModel.getTexts(this.ID);
			this.mp3Path=guiWaTextModel.getMp3Path(this.ID);
			initMp3Player();
		}
		private function initMp3Player():void
		{
			mp3Player=new Mp3Player(this.mp3Path);
			mp3Player.addEventListener(Event.COMPLETE,on_sound_complete);
			mp3Player.addEventListener(Mp3PlayerEvent.COMPLETE,on_mp3_play_cpmplete);
		}
		private function on_sound_complete(e:Event):void
		{
			getIn();
		}
		private function getIn():void
		{
			animationIn=new AnimationIn();
			animationText=new SayText();
			animationText.visible=false;
			if(willPop)
			{
				inquireSwc=new InquireSwc();//询问是否前进的窗口
				guiwaContainer.addChild(inquireSwc);
				inquireSwc.x=300;inquireSwc.y=150;
				inquireSwc.no.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					dispatchEvent(new Event(Event.CLOSE));
					open=false;
					inquireSwc.no.mouseEnabled=false;
					getOut();//NO就退出
				});
				inquireSwc.yes.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					open=true;
					inquireSwc.yes.mouseEnabled=false;
					getOut();//yes也退出
				});
				PopUpManager.addPopUp(guiwaContainer,this, true);
		        PopUpManager.centerPopUp(guiwaContainer); 
			}else
			{
				this.addChild(guiwaContainer);
			}
			guiwaContainer.addChild(animationText);
			guiwaContainer.addChild(animationIn);
			animationIn.x=-200+xOffset;
			animationIn.y=50+yOffset;
			initMyTimerWithTask();
			animationIn.addFrameScript(animationIn.totalFrames-10,showSayText);
			animationIn.addFrameScript(animationIn.totalFrames-1,getInComplete);
		}
		private function on_mp3_play_cpmplete(e:Mp3PlayerEvent):void
		{
			getOut();
		}
		//退出
		private function getOut():void
		{
			isClosing=true;
			animationOut=new AnimationOut();
			guiwaContainer.addChild(animationOut);
			animationOut.x=-190+xOffset;
			animationOut.y=50+yOffset;
			animationOut.addFrameScript(animationOut.totalFrames-1,dispose);
			if(animationClose!=null)
			{
				animationClose.parent.removeChild(animationClose);
				animationClose=null;
			}
			if(animationText!=null)
			{
				animationText.parent.removeChild(animationText);
				animationText=null;
			}
			if(animationSay!=null)
			{
				animationSay.stop();
				animationSay.parent.removeChild(animationSay);
				animationSay=null;
			}
			if(animationIn!=null)
			{
				animationIn.stop();
				animationIn.parent.removeChild(animationIn);
				animationIn=null
			}
		}
		public function dispose():void
		{
			if(myTimerWithTask!=null)
			{
				myTimerWithTask.removeEventListener(Event.CHANGE,on_time_change);
				myTimerWithTask=null;
			}
			if(mp3Player!=null)
			{
				mp3Player.removeEventListener(Mp3PlayerEvent.COMPLETE,on_mp3_play_cpmplete);
				mp3Player.close();
				mp3Player=null;
			}
			if(animationOut!=null)
			{
				animationOut.stop();
				animationOut.parent.removeChild(animationOut);
				animationOut=null;
			}
			if(animationText!=null)
			{
				animationText.parent.removeChild(animationText);
				animationText=null;
			}
			if(animationClose!=null)
			{
				animationClose.parent.removeChild(animationClose);
				animationClose=null;
			}
			if(animationSay!=null)
			{
				animationSay.parent.removeChild(animationSay);
				animationSay=null;
			}
			if(inquireSwc!=null)
			{
				inquireSwc=null;
			}
			if(willPop)
			{
				PopUpManager.removePopUp(guiwaContainer);
			}
			if(open)
			{
				dispatchEvent(new Event(Event.OPEN));
			}
			if(guiwaContainer!=null)
			{
				guiwaContainer=null;
			}
//			MainSystem.getInstance().removePluginById("AnimationModule");
		}
		private function initMyTimerWithTask():void
		{
			myTimerWithTask=new MyTimerWithTask(times);
			myTimerWithTask.addEventListener(Event.CHANGE,on_time_change);
		}
		private function on_time_change(e:Event):void
		{
			if(texts.length>0)
			{
				var currentText:String=texts.shift();
				if(animationText!=null)
				{
					animationText.text.text=currentText;
				}
			}
		}
		//显示说话的文本
		private function showSayText():void
		{
			if(animationText!=null)
			{
				animationText.visible=true;
				animationText.x=50+xOffset;
				animationText.y=20+yOffset;
				Tweener.addTween(animationText,{x:animationText.x-animationText.width+230,time:1});
				animationText.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				animationText.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			}
		}
		//出场完毕
		private function getInComplete():void
		{
			say();
			if(mp3Player!=null)
			{
				mp3Player.play();
			}
		}
		//说话
		private function say():void
		{
			if(animationIn!=null)
			{
				animationIn.stop();
				animationIn.parent.removeChild(animationIn);
				animationIn=null;
			}
			if(!isClosing)
			{
				animationSay=new AnimationSay();
				guiwaContainer.addChild(animationSay);
				animationSay.x=122+xOffset;
				animationSay.y=141+yOffset;
				animationSay.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				animationSay.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			}
		}
		private function onMouseOver(e:MouseEvent):void
		{
			Tweener.addTween(animationClose,{alpha:1,time:1});
		}
		private function onMouseOut(e:MouseEvent):void
		{
			Tweener.addTween(animationClose,{alpha:0,time:5});
		}
	}
}
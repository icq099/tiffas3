package lxfa.animation.view
{
	import caurina.transitions.Tweener;
	
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.animation.model.GuiWaTextModel;
	import lxfa.utils.MyTimerWithTask;
	import lxfa.view.event.Mp3PlayerEvent;
	import lxfa.view.player.Mp3Player;
	
	import mx.core.UIComponent;
	
	public class AnimationBase  extends UIComponent
	{
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
		private var willPop:Boolean=false;//是否需要POP出来
		private var inquireSwc:InquireSwc;
		private var open:Boolean=false;//是否开启下一个场景
		private var isClosing:Boolean=false;//桂娃是否处于关闭状态
		public function AnimationBase()
		{
			MainSystem.getInstance().addAPI("showGuiWa",init);
			MainSystem.getInstance().addAPI("removeGuiWa",getOut);
		}
		public function init(ID:int,willPop:Boolean=false):UIComponent
		{
			this.addChild(AnimationContainer.getInstance());
			open=false;//默认不开启下一个场景
			isClosing=false;
			this.ID=ID;
			this.willPop=willPop;
			guiWaTextModel=new GuiWaTextModel(guiWaTextPath);
			guiWaTextModel.addEventListener(Event.COMPLETE,onModelComplete);
			addCloseButton();//添加关闭按钮
			MainSystem.getInstance().addEventListener(PluginEvent.UPDATE,on_update);
			return AnimationContainer.getInstance();
		}
		private function on_update(e:PluginEvent):void
		{
			MainSystem.getInstance().removeEventListener(PluginEvent.UPDATE,on_update);
			MainSystem.getInstance().runAPIDirect("removeGuiWa",[]);
		}
		private function addCloseButton():void
		{
			AnimationContainer.getInstance().addChild(AnimationCloseBase.getInstance());//添加关闭按钮
			AnimationCloseBase.getInstance().x=200+xOffset;
			AnimationCloseBase.getInstance().y=0+yOffset;
			AnimationCloseBase.getInstance().alpha=0;
			AnimationCloseBase.getInstance().addEventListener(MouseEvent.CLICK,onCloseButtonClick);
		}
		private function onCloseButtonClick(e:MouseEvent):void
		{
			AnimationCloseBase.getInstance().mouseEnabled=false;
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
			trace("进来");
			if(willPop)
			{
				inquireSwc=new InquireSwc();//询问是否前进的窗口
//				guiwaContainer.addChild(inquireSwc);
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
//				PopUpManager.addPopUp(guiwaContainer,this, true);
//		        PopUpManager.centerPopUp(guiwaContainer); 
			}else
			{
//				this.addChild(guiwaContainer);
			}
			AnimationContainer.getInstance().addChild(AnimationSayTextBase.getInstance());
			AnimationContainer.getInstance().addChild(AnimationGetInBase.getInstance());
			AnimationGetInBase.getInstance().gotoAndPlay(0);
			AnimationGetInBase.getInstance().x=-200+xOffset;
			AnimationGetInBase.getInstance().y=50+yOffset;
			initMyTimerWithTask();
			AnimationGetInBase.getInstance().addFrameScript(AnimationGetInBase.getInstance().totalFrames-10,showSayText);
			AnimationGetInBase.getInstance().addFrameScript(AnimationGetInBase.getInstance().totalFrames-1,getInComplete);
		}
		private function on_mp3_play_cpmplete(e:Mp3PlayerEvent):void
		{
			getOut();
		}
		//退出
		private function getOut():void
		{
			isClosing=true;
			AnimationContainer.getInstance().addChild(AnimationGetOutBase.getInstance());
			AnimationGetOutBase.getInstance().gotoAndPlay(0);
			AnimationGetOutBase.getInstance().x=-190+xOffset;
			AnimationGetOutBase.getInstance().y=50+yOffset;
			AnimationGetOutBase.getInstance().addFrameScript(AnimationGetOutBase.getInstance().totalFrames-1,dispose);
			AnimationCloseBase.getInstance().hide();
			AnimationSayTextBase.getInstance().hide();
			AnimationSayBase.getInstance().hide();
			AnimationGetInBase.getInstance().hide();
		}
		public function dispose():void
		{
			if(mp3Player!=null)
			{
				mp3Player.removeEventListener(Mp3PlayerEvent.COMPLETE,on_mp3_play_cpmplete);
				mp3Player.close();
				mp3Player=null;
			}
			if(myTimerWithTask!=null)
			{
				myTimerWithTask.removeEventListener(Event.CHANGE,on_time_change);
				myTimerWithTask=null;
			}
			AnimationGetOutBase.getInstance().hide();
			AnimationSayTextBase.getInstance().hide();
			AnimationCloseBase.getInstance().hide();
			AnimationSayBase.getInstance().hide();
			if(inquireSwc!=null)
			{
				inquireSwc=null;
			}
			if(willPop)
			{
//				PopUpManager.removePopUp(guiwaContainer);
			}
			if(open)
			{
				dispatchEvent(new Event(Event.OPEN));
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
				AnimationSayTextBase.getInstance().setText(currentText);
			}
		}
		//显示说话的文本
		private function showSayText():void
		{
			trace("文本");
			AnimationSayTextBase.getInstance().visible=true;
			AnimationSayTextBase.getInstance().x=50+xOffset;
			AnimationSayTextBase.getInstance().y=20+yOffset;
			Tweener.addTween(AnimationSayTextBase.getInstance(),{x:AnimationSayTextBase.getInstance().x-AnimationSayTextBase.getInstance().width+230,time:1});
			AnimationSayTextBase.getInstance().addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			AnimationSayTextBase.getInstance().addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
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
			AnimationGetInBase.getInstance().hide();
			trace("说话");
			if(!isClosing)
			{
				AnimationContainer.getInstance().addChild(AnimationSayBase.getInstance());
				AnimationSayBase.getInstance().gotoAndPlay(0);
				AnimationSayBase.getInstance().x=122+xOffset;
				AnimationSayBase.getInstance().y=141+yOffset;
				AnimationSayBase.getInstance().addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				AnimationSayBase.getInstance().addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			}
		}
		private function onMouseOver(e:MouseEvent):void
		{
			Tweener.addTween(AnimationCloseBase.getInstance(),{alpha:1,time:1});
		}
		private function onMouseOut(e:MouseEvent):void
		{
			Tweener.addTween(AnimationCloseBase.getInstance(),{alpha:0,time:5});
		}
	}
}
package lxfa.animation.view
{
	import caurina.transitions.Tweener;
	
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lxfa.animation.model.GuiWaTextModel;
	import lxfa.utils.MyTimerWithTask;
	import lxfa.view.event.Mp3PlayerEvent;
	import lxfa.view.player.Mp3Player;
	
	public class AnimationBase  extends Sprite
	{
		private var animationIn:AnimationIn;
		private var animationText:SayText;
		private var animationSay:AnimationSay;
		private var animationOut:AnimationOut;
		private var animationClose:AnimationClose;//桂娃的关闭按钮
		private var guiWaTextModel:GuiWaTextModel;
		private var myTimerWithTask:MyTimerWithTask;
		private var texts:Array=new Array;
		private var times:Array=new Array();
		private var mp3Path:String;
		private var ID:int;
		private var mp3Player:Mp3Player;//说话的内容
		private var guiWaTextPath:String="xml/GuiWaText.xml";//model的路径
		public function AnimationBase()
		{
			MainSystem.getInstance().addAPI("showGuiWa",initGuiWaTextModel);
			
		}
		public function initGuiWaTextModel(ID:int):void
		{
			this.ID=ID;
			guiWaTextModel=new GuiWaTextModel(guiWaTextPath);
			guiWaTextModel.addEventListener(Event.COMPLETE,onModelComplete);
			addCloseButton();
			this.x=680;
			this.y=300;
		}
		private function addCloseButton():void
		{
			animationClose=new AnimationClose();
			this.addChild(animationClose);
			animationClose.x=200;
			animationClose.y=0;
			animationClose.alpha=0;
			animationClose.addEventListener(MouseEvent.CLICK,onCloseButtonClick);
		}
		private function onCloseButtonClick(e:MouseEvent):void
		{
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
			this.addChild(animationText);
			this.addChild(animationIn);
			animationIn.x=-200;
			animationIn.y=50;
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
			animationClose.parent.removeChild(animationClose);
			animationClose=null;
			animationText.parent.removeChild(animationText);
			animationText=null;
			animationSay.parent.removeChild(animationSay);
			animationSay=null;
			animationOut=new AnimationOut();
			this.addChild(animationOut);
			animationOut.x=-190;
			animationOut.y=50;
			animationOut.addFrameScript(animationOut.totalFrames-1,dispose);
		}
		public function dispose():void
		{
			myTimerWithTask.removeEventListener(Event.CHANGE,on_time_change);
			myTimerWithTask=null;
			mp3Player.removeEventListener(Mp3PlayerEvent.COMPLETE,on_mp3_play_cpmplete);
			mp3Player.close();
			mp3Player=null;
			animationOut.stop();
			animationOut.parent.removeChild(animationOut);
			animationOut=null;
			MainSystem.getInstance().removePluginById("AnimationModule");
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
				animationText.text.text=currentText;
			}
		}
		//显示说话的文本
		private function showSayText():void
		{
			animationText.visible=true;
			animationText.y=20;
			animationText.x=50;
			Tweener.addTween(animationText,{x:animationText.x-animationText.width+230,time:1});
			animationText.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			animationText.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
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
			animationIn.stop();
			animationIn.parent.removeChild(animationIn);
			animationIn=null;
			animationSay=new AnimationSay();
			this.addChild(animationSay);
			animationSay.x=122;
			animationSay.y=141;
			animationSay.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			animationSay.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
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
package lxfa.animation.view
{
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
		private var guiwa:GuiWaSwc;//桂娃的SWC文件
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
			MainSystem.getInstance().addAPI("setAnimationLocation",setLocation);
			MainSystem.getInstance().runAPIDirect("showGuiWa",[15]);
		}
		private function initMp3Player():void
		{
			mp3Player=new Mp3Player(this.mp3Path);
			mp3Player.addEventListener(Event.COMPLETE,on_sound_complete);
			mp3Player.addEventListener(Mp3PlayerEvent.COMPLETE,on_mp3_play_cpmplete);
		}
		private function on_mp3_play_cpmplete(e:Mp3PlayerEvent):void
		{
			hide();
		}
		private function on_sound_complete(e:Event):void
		{
			initGuiWaSwc();
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
				guiwa.introductionText.text.text=currentText;
			}
		}
		public function initGuiWaTextModel(ID:int):void
		{
			this.ID=ID;
			guiWaTextModel=new GuiWaTextModel(guiWaTextPath);
			guiWaTextModel.addEventListener(Event.COMPLETE,onModelComplete);
		}
		private function onModelComplete(e:Event):void
		{
			this.times=guiWaTextModel.getTimes(this.ID);
			this.texts=guiWaTextModel.getTexts(this.ID);
			this.mp3Path=guiWaTextModel.getMp3Path(this.ID);
			initMp3Player();
		}
		private function initGuiWaSwc():void
		{
			guiwa=new GuiWaSwc();
			guiwa.x=800;
			guiwa.y=350;
			guiwa.hide1.stop();
			guiwa.hide2.stop();
			guiwa.show1.stop();
			guiwa.show2.stop();
			guiwa.show3.stop();
			guiwa.say.stop();
			guiwa.hide1.visible=false;
			guiwa.hide2.visible=false;
			guiwa.show1.visible=false;
			guiwa.show2.visible=false;
			guiwa.show3.visible=false;
			guiwa.say.visible=false;
			guiwa.introductionText.visible=false;
			this.addChild(guiwa);
			show();
		}
		public function setLocation(x:String,y:String):void
		{
			this.x=int(x);
			this.y=int(y);
		}
		////////////////////////////////桂娃的动作
		private function show():void
		{
			guiwa.show1.visible=true;
			guiwa.show2.visible=true;
			guiwa.show3.visible=true;
			guiwa.show1.play();
			guiwa.show2.play();
			guiwa.show3.play();
			initMyTimerWithTask();
			this.addEventListener(Event.ENTER_FRAME,on_show_ENTER_FRAME);
		}
		private function on_show_ENTER_FRAME(e:Event):void//一直检测到桂娃出场完毕
		{
			if(guiwa==null)
			{
				this.removeEventListener(Event.ENTER_FRAME,on_show_ENTER_FRAME);
			}
			else if(guiwa.show1.currentFrame==guiwa.show1.totalFrames)
			{
				say();
				mp3Player.play();
				this.removeEventListener(Event.ENTER_FRAME,on_show_ENTER_FRAME);
			}
		}
		private function hide():void
		{
			guiwa.say.visible=false;
			guiwa.introductionText.visible=false;
			guiwa.say.stop();
			guiwa.shadow.visible=false;
			guiwa.hide1.visible=true;
			guiwa.hide1.play();
			guiwa.hide1.addEventListener(Event.ENTER_FRAME,on_hide1_ENTER_FRAME);
		}
		private function on_hide1_ENTER_FRAME(e:Event):void
		{
			if(guiwa.hide1.currentFrame==guiwa.hide1.totalFrames)
			{
				guiwa.hide1.removeEventListener(Event.ENTER_FRAME,on_hide1_ENTER_FRAME);
				guiwa.hide2.visible=true;
				guiwa.hide2.play();
				guiwa.hide2.addEventListener(Event.ENTER_FRAME,on_hide2_ENTER_FRAME);
			}
		}
		private function on_hide2_ENTER_FRAME(e:Event):void
		{
			if(guiwa.hide2.currentFrame==guiwa.hide2.totalFrames)
			{
				guiwa.hide2.removeEventListener(Event.ENTER_FRAME,on_hide2_ENTER_FRAME);
				guiwa.hide2.visible=false;
				guiwa.hide2.stop();
				MainSystem.getInstance().removePluginById("AnimationModule");
			}
		}

		private function say():void
		{
			guiwa.introductionText.visible=true;
			guiwa.show1.visible=false;
			guiwa.show2.visible=false;
			guiwa.show3.visible=false;
			guiwa.say.visible=true;
			guiwa.say.play();
			guiwa.say.addEventListener(MouseEvent.CLICK,on_say_click);
		}
		private function on_say_click(e:MouseEvent):void
		{
			MainSystem.getInstance().removePluginById("AnimationModule");
		}
		public function dispose():void
		{
			guiwa.say=null;
			guiwa.show1=null;
			guiwa.show2=null;
			guiwa.show3=null;
			guiwa.hide1=null;
			guiwa.hide2=null;
			guiwa=null;
			mp3Player.close();
			mp3Player=null;
			myTimerWithTask.removeEventListener(Event.CHANGE,on_time_change);
			myTimerWithTask=null;
		}
	}
}
package lxf.FishPanel{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class FishPanel extends Sprite
	{
		private var fpp:FishPanelPlugin=null;
		private var defaultLocationX:int=5;
		private var defaultLocationY:int=48;
		private var test:SampleList;
		public function FishPanel()
		{
			fpp=new FishPanelPlugin();
			fpp.close.addEventListener(MouseEvent.CLICK,fppCloseClickEvent);
			//载入XML
			test=new SampleList();
			test.addEventListener(SampleLoadedEvent.sampleLoaded,traceStr);
			//添加API
			MainSystem.getInstance().addAPI("showFishPanel",showFishPanel);
			MainSystem.getInstance().addAPI("removeFishPanel",removeishPanel);
		}
		//API函数
		private function showFishPanel():void
		{
			addChild(fpp);
		}
		private function removeishPanel():void
		{
			removeChild(fpp);
		}
		//////////////
		private function traceStr(e:SampleLoadedEvent):void
		{
			addButtons();
		}
		private function fppCloseClickEvent(e:MouseEvent):void
		{
			trace("fuck");
			MainSystem.getInstance().runAPIDirect("removeFishPanel");
		}
		///添加和删除按钮
		private function addButtons():void
		{
			var temp:Array=test.readSampleList(1);
			for(var i:int;i<temp.length;i++)
			{
				var fpb:FishPanelButtons=new FishPanelButtons(temp[i]);
				fpb.x=defaultLocationX;
				fpb.y=defaultLocationY+i*30;
				fpp.addChild(fpb);
			}
		}
	}
}

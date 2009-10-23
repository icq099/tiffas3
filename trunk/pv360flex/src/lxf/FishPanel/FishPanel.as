package lxf.FishPanel{
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
			addFppButtonClickEvent();
			this.addChild(fpp);
			//载入XML
			test=new SampleList();
			test.addEventListener(SampleLoadedEvent.sampleLoaded,traceStr);
		}
		private function traceStr(e:SampleLoadedEvent):void
		{
			addButtons();
		}
		private function addFppButtonClickEvent():void
		{
			fpp.close.addEventListener(MouseEvent.CLICK,fppCloseClickEvent);
		}
		private function fppCloseClickEvent(e:MouseEvent):void
		{

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

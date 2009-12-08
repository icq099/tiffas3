package assets
{
	import assets.model.HotPointStructManager;
	
	import fl.controls.Button;
	
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import view.PopMenusFlexView;
	public class Panel2Handler
	{
		private var hpsm:HotPointStructManager;
		public function Panel2Handler(hpsm:HotPointStructManager)
		{
			SamplePanel.sp.panel2.preview.label="预览";
			SamplePanel.sp.panel2.update.label="开始上传";
			SamplePanel.sp.panel2.preview.addEventListener(MouseEvent.CLICK,previewButtonClickEvent);
			SamplePanel.sp.panel2.update.addEventListener(MouseEvent.CLICK,startUpdateButtonClickEvent);
			this.hpsm=hpsm;
		}
		private function previewButtonClickEvent(e:MouseEvent):void
		{
			var popMenusFlexView:PopMenusFlexView=new PopMenusFlexView();
			popMenusFlexView.addEventListener(FlexEvent.CREATION_COMPLETE,popMenusFlexViewComplete);
			popMenusFlexView.addEventListener(CloseEvent.CLOSE,popMenusFlexViewClose);
			Application.application.addChild(popMenusFlexView);
		}
		private function popMenusFlexViewClose(e:CloseEvent):void
		{
			Application.application.removeChild(e.currentTarget);
		}
		private function popMenusFlexViewComplete(e:FlexEvent):void
		{
			//添加图片
			if(this.hpsm.hps.image.length>0)
			{
				var imageCount:int=this.hpsm.hps.image.length;
				for(var i:int=0;i<imageCount;i++)
				{
					PopMenusFlexView(e.currentTarget).addPicture(this.hpsm.hps.image[i]);
					PopMenusFlexView(e.currentTarget).refreshPicture();
				}
			}
			//添加说明
			if(this.hpsm.hps.text.length>0)
			{
				PopMenusFlexView(e.currentTarget).loadText(this.hpsm.hps.text,true);
			}
			//设置大小
			PopMenusFlexView(e.currentTarget).width=700;
			PopMenusFlexView(e.currentTarget).height=500;
		}
		private function startUpdateButtonClickEvent(e:MouseEvent):void
		{
			Button(e.currentTarget).enabled=false;
			this.hpsm.startToUpdate();
		}
	}
}
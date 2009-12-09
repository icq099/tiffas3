package assets
{
	import assets.model.HotPointStructManager;
	
	import fl.controls.Button;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import remoteobject.HotPointStruct;
	
	import view.PopMenusFlexView;
	public class Panel2Handler
	{
		private var hps:HotPointStruct;
		private var hpsm:HotPointStructManager;
		public function Panel2Handler(hps:HotPointStruct,hpsm:HotPointStructManager)
		{
			SamplePanel.sp.panel2.preview.label="预览";
			SamplePanel.sp.panel2.update.label="开始上传";
			SamplePanel.sp.panel2.preview.addEventListener(MouseEvent.CLICK,previewButtonClickEvent);
			SamplePanel.sp.panel2.update.addEventListener(MouseEvent.CLICK,startUpdateButtonClickEvent);
			this.hps=hps;
			this.hpsm=hpsm;
		}
		private function previewButtonClickEvent(e:MouseEvent):void
		{
			var popMenusFlexView:PopMenusFlexView=PopUpManager.createPopUp(DisplayObject(Application.application),PopMenusFlexView,true) as PopMenusFlexView;
			popMenusFlexView.width=700;
			popMenusFlexView.height=400;
			PopUpManager.centerPopUp(popMenusFlexView);
			popMenusFlexViewComplete(popMenusFlexView);
			popMenusFlexView.addEventListener(CloseEvent.CLOSE,popMenusFlexViewClose);
		}
		private function popMenusFlexViewClose(e:CloseEvent):void
		{
			PopUpManager.removePopUp(PopMenusFlexView(e.currentTarget));
		}
		private function popMenusFlexViewComplete(currentTarget:PopMenusFlexView):void
		{
			//添加图片
			if(this.hps.image.length>0)
			{
				var imageCount:int=this.hps.image.length;
				for(var i:int=0;i<imageCount;i++)
				{
					PopMenusFlexView(currentTarget).addPicture(this.hps.image[i]);
					PopMenusFlexView(currentTarget).refreshPicture();
				}
			}
			//添加说明
			if(this.hps.text.length>0)
			{
				PopMenusFlexView(currentTarget).loadText(this.hps.text,true);
			}
			//设置大小
			PopMenusFlexView(currentTarget).width=700;
			PopMenusFlexView(currentTarget).height=500;
		}
		private function startUpdateButtonClickEvent(e:MouseEvent):void
		{
			Button(e.currentTarget).enabled=false;
			this.hpsm.startToUpdate();
		}
	}
}
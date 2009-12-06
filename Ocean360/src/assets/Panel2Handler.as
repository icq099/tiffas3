package assets
{
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.events.FlexEvent;
	
	import view.PopMenusFlexView;
	public class Panel2Handler
	{
		public function Panel2Handler()
		{
			Application.application.startUpdateButton.addEventListener(MouseEvent.CLICK,startUpdateButtonClickEvent);
			Application.application.previewButton.addEventListener(MouseEvent.CLICK,previewButtonClickEvent);
		}
		private function previewButtonClickEvent(e:MouseEvent):void
		{
			var popMenusFlexView:PopMenusFlexView=new PopMenusFlexView();
			popMenusFlexView.addEventListener(FlexEvent.CREATION_COMPLETE,popMenusFlexViewComplete);
			Application.application.addChild(popMenusFlexView);
		}
		private function popMenusFlexViewComplete(e:FlexEvent):void
		{
			//添加图片
			if(Application.application.hpsm.hps.image.length>0)
			{
				var imageCount:int=Application.application.hpsm.hps.image.length;
				for(var i:int=0;i<imageCount;i++)
				{
					PopMenusFlexView(e.currentTarget).addPicture(Application.application.hpsm.hps.image[i]);
					PopMenusFlexView(e.currentTarget).refreshPicture();
				}
			}
			//添加说明
			if(Application.application.hpsm.hps.text.length>0)
			{
				PopMenusFlexView(e.currentTarget).loadText(Application.application.hpsm.hps.text,true);
			}
			//设置大小
			PopMenusFlexView(e.currentTarget).width=700;
			PopMenusFlexView(e.currentTarget).height=500;
		}
		private function startUpdateButtonClickEvent(e:MouseEvent):void
		{
			Application.application.startUpdateButton.enabled=false;
			Application.application.hpsm.startToUpdate();
		}
	}
}
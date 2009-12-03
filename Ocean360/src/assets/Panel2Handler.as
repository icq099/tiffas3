package assets
{
	import communication.MainSystem;
	
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	public class Panel2Handler
	{
		public function Panel2Handler()
		{
			Application.application.startUpdateButton.addEventListener(MouseEvent.CLICK,startUpdateButtonClickEvent);
			Application.application.previewButton.addEventListener(MouseEvent.CLICK,previewButtonClickEvent);
		}
		private function previewButtonClickEvent(e:MouseEvent):void
		{
			MainSystem.getInstance().runAPIDirect("showSample",["1"]);
		}
		private function startUpdateButtonClickEvent(e:MouseEvent):void
		{
			Application.application.startUpdateButton.enabled=false;
			Application.application.sp.p1h.hpsm.startToUpdate();
		}
	}
}
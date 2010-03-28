package lxfa.view.loadings
{
	import flash.events.ProgressEvent;
	
	import mx.core.UIComponent;
	
	public class LoadingWaveRota extends UIComponent
	{
		private var grayLoadingWaveRota:GrayLoadingWaveRota
		public function LoadingWaveRota()
		{
			grayLoadingWaveRota=new GrayLoadingWaveRota();
			this.addChild(grayLoadingWaveRota);
		}
		public function updateByProgressEvent(e:ProgressEvent):void{
			grayLoadingWaveRota.percentageText.text=Math.round((e.bytesLoaded/e.bytesTotal)*100)+"%";
		}
	}
}
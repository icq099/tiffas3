package yzhkof.loadings
{
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.text.TextField;

	public class LoadingWaveRota extends Sprite implements IYzhkofProgressLoading
	{
		[Embed(source="asset/myloadings.swf",symbol="LoadingWaveRota")]
		private static const Loading:Class;
		private static const upper:Number=45;
		private static const lower:Number=192;
	
		private var _loading:Sprite;
		
		public function LoadingWaveRota()
		{
			super();
			
			_loading=new Loading();
			
			addChild(_loading);
			
			maskMc.y=lower;
		}
		public function updateByProgressEvent(e:ProgressEvent):void{
			
			percentText.text=Math.round((e.bytesLoaded/e.bytesTotal)*100)+"%";
			
			maskMc.y=lower-(e.bytesLoaded/e.bytesTotal)*(lower-upper);
		
		}
		public function updateByNumber(load_number:Number,total:Number):void{
		
		}
		private function get percentText():TextField{
			
			return _loading.getChildByName("percent_text") as TextField;
		
		}
		private function get maskMc():Sprite{
			
			return _loading.getChildByName("mask_mc") as Sprite;
		
		}
		
	}
}
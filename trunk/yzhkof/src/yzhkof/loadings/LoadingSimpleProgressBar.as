package yzhkof.loadings
{
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	
	import yzhkof.MyGraphy;

	public class LoadingSimpleProgressBar extends Sprite implements IYzhkofProgressLoading
	{
		private var container_mc:Sprite;
		private var progress_bar:Sprite;
		
		private var c_width:Number;
		private var c_height:Number;
		private var colour:uint;
		private var offset:Number;
				
		public function LoadingSimpleProgressBar(width:Number=100,height:Number=10,offset:Number=2,colour:uint=0x000000)
		{
			super();
			c_width=width;
			c_height=height;
			this.offset=offset;
			this.colour=colour;
			init();
		}
		
		public function updateByProgressEvent(e:ProgressEvent):void
		{
			
			progress_bar.scaleX=e.bytesLoaded/e.bytesTotal;
			
		}
		public function updateByNumber(load_number:Number,total:Number):void{
			
			progress_bar.scaleX=load_number/total;
		
		}
		private function init():void{
			
			container_mc=MyGraphy.drawRectangle(c_width,c_height,false,colour);
			progress_bar=MyGraphy.drawRectangle(c_width-2*offset,c_height-2*offset,true,colour);
			progress_bar.x=progress_bar.y=offset;
			addChild(container_mc)
			addChild(progress_bar);
		
		}
		
	}
}
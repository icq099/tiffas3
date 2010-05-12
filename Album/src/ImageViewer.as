package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import yzhkof.loader.CompatibleLoader;
	
	public class ImageViewer extends Sprite
	{
		protected var back:ImageView=new ImageView();
		protected var WIDTH:Number;
		protected var HEIGHT:Number;
		protected var preloader:Preloader=new Preloader();
		
		protected var url:String="";
		protected var loader:CompatibleLoader=new CompatibleLoader();
		public function ImageViewer(url:String="")
		{
			super();
			WIDTH=200;
			HEIGHT=200;
			this.url=url;
			init();
			updataDisplay();
		}
		protected function init():void
		{
			addChild(back);
			addChild(loader);
			addChild(preloader);
			
			loader.load(url);
			loader.addEventListener(Event.COMPLETE,__onComplete);
		}
		protected function updataDisplay():void
		{
			back.width=WIDTH;
			back.height=HEIGHT;
			preloader.x=back.width/2;
			preloader.y=back.height/2;
			
		}
		protected function __onComplete(e:Event):void
		{
			removeChild(preloader);
		}
		public function removeFromDisplayList():void
		{
			if(parent)
			{
				parent.removeChild(this);
				loader.unload();
			}
		}
	}
}
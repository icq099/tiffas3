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
		
		protected var data:PhotoData;
		protected var urlDataOn:String = "url";
		protected var loader:CompatibleLoader=new CompatibleLoader();
		public function ImageViewer(data:PhotoData)
		{
			super();
			this.data = data;
			WIDTH=200;
			HEIGHT=200;
			init();
			updataDisplay();
		}
		protected function init():void
		{
			addChild(back);
			addChild(loader);
			
			loadData(data);
			
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
			loader.visible=true;
			removeChild(preloader);
		}
		public function loadData(data:PhotoData):void
		{
			this.data = data;
			loader.visible = false;
			loader.load(data[urlDataOn]);
			addChild(preloader);
			preloader.x=back.width/2;
			preloader.y=back.height/2;
			
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
package plugins.lsd.AnimatePlayer.view
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import memory.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	public class AnimatePlayer extends UIComponent
	{
		//申明的变量
		 private var _urlanimte:String;
        //播放swf申明的变量
        private var loader:Loader;
		private var request:URLRequest;
		private var closeButton:Button_Close=new Button_Close();
		public function AnimatePlayer()
		{
		}
		public function load(url_swf:String):void{
			if(url_swf!=null){
				if(url_swf!=this._urlanimte){
					
					this._urlanimte=url_swf;
					loadAnimate();
				}
			}
	    }
	    private function loadAnimate():void{
			loader=new Loader();
			request=new URLRequest(_urlanimte);
			loader.load(request);
		    loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			closeButton.addEventListener(MouseEvent.CLICK,closeAnimate);
            addChild(loader);
            addChild(closeButton);closeButton.x=850;closeButton.y=60;
	    }
	    private function completeHandler(e:Event):void{
	    	loader.x=0;
	    	MemoryRecovery.getInstance().gcFun(loader.contentLoaderInfo,Event.COMPLETE,completeHandler);
	    	MovieClip(loader.content).addFrameScript(MovieClip(loader.content).totalFrames-1,movieCompleteHandler);
	    }
		private function movieCompleteHandler():void{
			dispose();
		}
		public function closeAnimate(e:MouseEvent=null):void{
			dispose();
		}
		public function dispose():void{
			_urlanimte=null;
			if(loader!=null)
			{
				MemoryRecovery.getInstance().gcFun(loader.contentLoaderInfo,Event.COMPLETE,completeHandler);
				if(loader.parent!=null)
				{
					removeChild(loader);
				}
				if(loader.content!=null)
				{
					MovieClip(loader.content).stop();
				}
				try
				{
					loader.close();
					loader.unload();
				}catch(e:Error)
				{
					
				}
				loader=null;
			}
			request=null;
			if(closeButton!=null)
			{
				MemoryRecovery.getInstance().gcFun(closeButton,MouseEvent.CLICK,closeAnimate);
				if(closeButton.parent!=null)
				{
					closeButton.parent.removeChild(closeButton);
				}
				closeButton=null;
			}
		}
	}
}
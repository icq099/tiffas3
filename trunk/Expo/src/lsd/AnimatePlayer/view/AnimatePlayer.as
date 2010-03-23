package lsd.AnimatePlayer.view
{
	import communication.MainSystem;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import lxfa.customMusic.CustomMusicManager;
	
	import mx.core.UIComponent;
	
	public class AnimatePlayer extends UIComponent
	{
		//申明的变量
		 private var _urlanimte:String;
        //播放swf申明的变量
        private var loader:Loader;
		private var request:URLRequest;
		private var closeButton:Button_Close=new Button_Close();
		private var is_open:Boolean=false;
		private var load_is_null:Boolean=true;
		private var outLoader:Loader;
		private var isClose:Boolean=false;
		public function AnimatePlayer()
		{
		}
		public function load(url_swf:String):void{
			if(!isClose)
			{
				if(url_swf!=null){
					if(url_swf!=this._urlanimte){
						
						this._urlanimte=url_swf;
						load_is_null=false;
						loadAnimate();
					}
				}else{
					//设置空	
					load_is_null=true;		
				}
			}else
			{
				isClose=false;
				dispose();
			}
	    }
	    private function loadAnimate():void{
	    	if(!isClose)
	    	{
		    	clearMC();
				loader=new Loader();
				request=new URLRequest(_urlanimte);
				loader.load(request);
			    loader.cacheAsBitmap=true;
			    loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
				closeButton.addEventListener(MouseEvent.CLICK,closeAnimate);
	            addChild(loader);
	            addChild(closeButton);closeButton.x=850;closeButton.y=60;
	            is_open=true;
	    	}else
			{
				isClose=false;
				dispose();
			}
	    }
	    private function completeHandler(e:Event):void{
	    	if(!isClose)
	    	{
		    	initOut();
		    	loader.x=0;
		    	MainSystem.getInstance().isBusy=false
		    	MovieClip(loader.content).addFrameScript(MovieClip(loader.content).totalFrames-1,movieCompleteHandler);
		    	if(!is_open){
		    		
		    		MovieClip(loader.content).stop();
		    	}
	    	}else
			{
				isClose=false;
				dispose();
			}
	    }
		private function movieCompleteHandler():void{
			if(!isClose)
			{
				removeChild(closeButton);closeButton=null;
	       	 	removeChild(loader);
				MovieClip(loader.content).stop();loader=null;
			}else
			{
				isClose=false;
				dispose();
			}
		}
		public function closeAnimate(e:MouseEvent=null):void{
			if(!MainSystem.getInstance().isBusy)
			{
				if(!isClose)
				{
					if(is_open){
						
						try{
							removeChild(closeButton);closeButton=null;
			           	 	removeChild(loader);
							MovieClip(loader.content).stop();loader=null;
							this.addChild(outLoader);
							MovieClip(outLoader.content).gotoAndPlay(0);
							MovieClip(outLoader.content).addFrameScript(MovieClip(outLoader.content).totalFrames-1,dispose);
						}catch(e:Error){
							trace(e);
						}
			            is_open=false;
			  		}
				}else
				{
					isClose=false;
					dispose();
				}
			}
		}
		//初始化退出的效果
		private function initOut():void
		{
			if(!isClose)
			{
				outLoader=new Loader();
				outLoader.load(new URLRequest("swf/animate/animateOut.swf"));
				outLoader.cacheAsBitmap=true;
				outLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,out_complete);
			}else
			{
				isClose=false;
				dispose();
			}
		}
		//退出的效果加载完毕的时候
	    private function out_complete(e:Event):void{
	    	if(!isClose)
	    	{
		    	if(outLoader!=null)
		    	{
			    	outLoader.x=200;
			    	outLoader.y=-330;
			    	MovieClip(outLoader.content).stop();
		    	}
	    	}else
	    	{
	    		isClose=false;
	    		dispose();
	    	}
	    }
		private function clearMC():void{
			
			if(loader!=null){
				MovieClip(loader.content).addFrameScript(MovieClip(loader.content).totalFrames-1,null);
				try{
					loader.unloadAndStop();
					removeChild(loader);
				}catch(e:Error){
				}
				loader=null
			}
		}
		public function dispose():void{
			if(!isClose)
			{
				isClose=true;
				if(outLoader!=null)
				{
					if(outLoader.parent!=null)
					{
						outLoader.parent.removeChild(outLoader);
					}
					if(outLoader.content!=null)
					{
						MovieClip(outLoader.content).stop();
					}
					outLoader=null;
				}
				if(loader!=null)
				{
					if(loader.parent!=null)
					{
						removeChild(loader);
					}
					if(loader.content!=null)
					{
						MovieClip(loader.content).stop();
					}
					loader=null;
				}
				if(closeButton!=null)
				{
					removeChild(closeButton);
					closeButton=null;
				}
			}
		}
	}
}
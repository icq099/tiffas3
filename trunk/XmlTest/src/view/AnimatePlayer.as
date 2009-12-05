package view
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import gs.TweenLite;
	
	public class AnimatePlayer extends Sprite
	{
		
		[Embed (source="asset/Animate.swf",symbol="OpenButton")]
		private var OpenButton:Class;
		
		/* [Embed (source="asset/Animate.swf",symbol="CloseButton")]
		private var CloseButton:Class; */
		
		
		//申明的变量
		 private var _urlanimte:String;
         private var offsetWidth:Number;
         
        //播放swf申明的变量
	
        private var loader:Loader;
		private var request:URLRequest;
		private var openButton:SimpleButton=new OpenButton();
		private var closeButton:Button_Close=new Button_Close();
		
		private var is_open:Boolean=false;
		
		private var load_is_null:Boolean=true;
		
		public function AnimatePlayer()
		{
			
			//addChild(closeButton);
			closeButton.y=25;
			openButton.visible=false;
			
		}
		public function animateLoad(url_swf:String,offsetWidth:Number=150):void{
			
			if(url_swf!=null){
				if(url_swf!=this._urlanimte){
					
					this._urlanimte=url_swf;
					this.offsetWidth=offsetWidth;
					load_is_null=false;
					
					loadAnimate();
					
				}
			}else{
				//设置空	
				load_is_null=true;		
			}
            
	    }
	    private function loadAnimate():void{
	    	
	    	clearMC();
			
			loader=new Loader();
			request=new URLRequest(_urlanimte);
			loader.load(request);
		     
		    loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			closeButton.addEventListener(MouseEvent.CLICK,closeAnimate);
            openButton.addEventListener(MouseEvent.CLICK,openAnimate);
                        	
            addChild(loader);
            addChild(closeButton);
            is_open=true;
	    
	    }
	    private function completeHandler(e:Event):void{
	    	
	    	loader.x=-offsetWidth;
	    	MovieClip(loader.content).addFrameScript(MovieClip(loader.content).totalFrames-1,movieCompleteHandler);
	    	if(!is_open){
	    		
	    		MovieClip(loader.content).stop();
	    		
	    	}
	    	
	    
	    }
		private function animatevalue():String{
			
			   return _urlanimte;
			
		}
		private function movieCompleteHandler():void{
			
			closeAnimate(null);
		
		}
		public function closeAnimate(e:MouseEvent=null):void{
			
			if(is_open){
				
				try{
					
					removeChild(closeButton);
	           	 	removeChild(loader);
					MovieClip(loader.content).stop();
					
				}catch(e:Error){
					
					
				
				}
				
				addChild(openButton);
				TweenLite.from(openButton,0.5,{alpha:0,x:20});
				
	            is_open=false;
	            
	  		}

		}
		
		public function openAnimate(e:MouseEvent=null):void{
			
			if((!is_open)&&(load_is_null==false)){
				
				addChild(closeButton);
				TweenLite.from(closeButton,0.5,{alpha:0,x:20});
				try{
					
					addChild(loader);
					removeChild(openButton);
					MovieClip(loader.content).gotoAndPlay(0);
					
				}catch(e:Error){
				
				}
				
				is_open=true;
				
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
		
		

	}
}
package lsd
{
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import gs.TweenLite;
	
	public class SwfBasicPlayer extends Sprite
	{
		public function SwfBasicPlayer()
		{
			 
		}
		
	    [Embed (source="asset/Map.swf",symbol="MapBackGround")]
	    private static var MapBackGround:Class;
	    private var map_back:Sprite=new MapBackGround();
	    [Embed (source="asset/Map.swf",symbol="LoadingSimpleRota")]
	    private static var LoadingSimpleRota:Class;
	    private var rota:Sprite=new LoadingSimpleRota();
	    [Embed (source="asset/Map.swf",symbol="CloseButton")]
	    private static var CloseButton:Class;
        private var close:SimpleButton=new CloseButton();
		private var _url:String;
		private var loader:Loader;
		private var request:URLRequest;
	    private const offset:Number=15;
	    private var content_width:Number;
	    private var content_heigth:Number;
	    private var maskSprite:Sprite;
	    
	    private var _forceWidth:Number=-1;
	    private var _forceHeight:Number=-1;

	    
	    
  
		//载入
		public function changeSwf(url:String):void{
			
			this._url=url;
			loader=new Loader();
			request=new URLRequest(url);
			loader.load(request);
			addChild(map_back);
			addChild(rota);
			addChild(close);
			close.x=map_back.width-24;
			close.y=23;
			loader.x=offset;
			loader.y=offset;
			rota.x=50;
			rota.y=60;
		    
		    
		    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			close.addEventListener(MouseEvent.CLICK,closeButton);
			
		}
		private function progressHandler(e:ProgressEvent):void{
			
			dispatchEvent(e);
			
		}
		private function completeHandler(e:Event):void{
						
						
			var d_width:Number=_forceWidth<=0?loader.width:_forceWidth;
			var d_height:Number=_forceHeight<=0?loader.height:_forceHeight;	
			
			content_width=loader.content.width;
			content_heigth=loader.content.height;
			
			 removeChild(rota);
			 
			 TweenLite.to(close,0.2,{x:d_width+5,y:offset+8});
			 TweenLite.to(map_back,0.2,{height:d_height+offset*2,width:d_width+offset*2,onComplete:function():void{
			 	
			 	//遮罩
			 	maskSprite=new Sprite();
			 	maskSprite.graphics.lineStyle();
			 	maskSprite.graphics.beginFill(0xFFFFFF);
			 	maskSprite.graphics.drawRect(offset,offset,d_width,d_height);
			 	loader.mask=maskSprite;
			 	addChild(maskSprite);
			 	addChild(loader);
			 	addChild(close);
			 	
			 	TweenLite.from(loader,0.5,{alpha:0})
			 
			 
			 }});
             dispatchEvent(e);
		
		}
		
		private function closeButton(e:Event):void{
			
			
			TweenLite.to(this,0.5,{alpha:0,onComplete:remove});
			

		}
		
		
		private function remove():void{
			
			if(parent!=null){
                
                parent.removeChild(this);

		   }
		    dispatchEvent(new Event(Event.CLOSE));
		}
		
		
		
		override public function set width(value:Number):void{
			
			map_back.width=value;
			loader.width=value-offset*2;
			
		}
		override public function get width():Number{
			
			return map_back.width;	
		
		}
		override public function set height(value:Number):void{
			
			map_back.height=value;
			loader.height=value-offset*2;
			
		}
		override public function get height():Number{
			
			return map_back.height;	
		
		}
		
		
		public function get contentWidth():Number{
			
			return content_width;
		
		}
		
		public function get contentHeight():Number{
			
			return content_heigth;
		
		}
		public function set forceWidth(value:Number):void{
			
			_forceWidth=value;	
		
		}
		public function get forceWidth():Number{
			
			return _forceWidth;	
		
		}
		public function set forceHeight(value:Number):void{
			
			_forceHeight=value;
		
		}
		public function get forceHeight():Number{
			
			return _forceHeight;	
		
		}
		
		

	}

}
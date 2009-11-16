package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import lsd.IPlayerBasic;
	
	import yzhkof.loader.SeriaCompatibleLoader;
	
	[Event(name="complete", type="flash.events.Event")]

	public class SerialPictureView extends Sprite implements IPlayerBasic
	{
		private var loader:SeriaCompatibleLoader;
		private var urls:Array=new Array();
		private var pictures:Array=new Array();
		private var buttons:Array=new Array();
		private var current_picture:int=0;
		private var total_picture:int=0;
		private var button_container:Sprite=new Sprite();
		
		public var PICTURE_WIDTH:Number;
		public var PICTURE_HEIGHT:Number;
		private var TWEEN_TIME:Number;
		private var BUTTON_DISTANCE:Number=5;
		
		public function SerialPictureView(p_width:Number=320,p_height:Number=240,tween_time:Number=1):void
		{
			
			super();
			loader=new SeriaCompatibleLoader()
			PICTURE_WIDTH=p_width;
			PICTURE_HEIGHT=p_height;
			TWEEN_TIME=tween_time;
			
		}
		public function add(source:Object):void{
			
			loader.add(source);
			urls.push(source);
		
		}
		public function stopAll():void{
			
			loader.clear();
		
		}
		public function loadPictures():void{
			
			loader.start();
			loader.addEventListener(Event.COMPLETE,onCompleteHandler);
		
		}
		public function changePicture(num:int):void{
			
			num=num%total_picture;
			TweenLite.to(pictures[current_picture],TWEEN_TIME,{alpha:0});
			TweenLite.to(pictures[num],TWEEN_TIME,{alpha:1});
			current_picture=num;
		
		}
		private function onCompleteHandler(e:Event):void{
			
			for each(var i:Object in urls){
				
				var bitmap:Bitmap=loader.getItem(i) as Bitmap;
				bitmap.width=PICTURE_WIDTH;
				bitmap.height=PICTURE_HEIGHT;
				pictures.push(bitmap);
				
			}
			
			total_picture=pictures.length;
			
			stopAll();
			init();
			dispatchEvent(new Event(Event.COMPLETE));
					
		}
		private function init():void{
			
			for each(var i:Bitmap in pictures){
				
				i.alpha=0
				addChild(i);
			
			}
			for(var j:int;j<pictures.length;j++){
				
				var button:PictureButton=new PictureButton();
				buttons.push(button);
				button.x=(BUTTON_DISTANCE+button.width)*j;
				button.textNum=j+1;
				button_container.addChild(button);
				
				button.addEventListener(MouseEvent.CLICK,function(e:Event):void{
					
					changePicture(buttons.indexOf(e.currentTarget));
				
				})
			
			}
			
			button_container.x=PICTURE_WIDTH-button_container.width;
			button_container.y=PICTURE_HEIGHT-button_container.height;
			
			if(pictures.length>1){
				
				addChild(button_container);
				
			}
			changePicture(current_picture);
		
		}
		
	}
}
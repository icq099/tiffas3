package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	import gs.easing.Strong;
	
	import yzhkof.effect.MyEffect;
	import yzhkof.ui.mouse.MouseManager;

	public class ImageBigViewer extends ImageViewer
	{
		private const OFFSET:Number=10;
		private const BOTTOM:Number=50;
		
		private var textfield:TextField;
				
		private static const mouseAsset:MouseAsset = new MouseAsset;
		private var closeBtn:Sprite = new CloseAsset;
		
		private var isMouseOnLoader:Boolean = false;
		
		public function ImageBigViewer(data:PhotoData)
		{
			urlDataOn = "url";
			super(data);
//			TipManager.getInstance().addTipTo(back,new CloseAsset,{offsetX:25,offsetY:25});
			loader.x=OFFSET;
			loader.y=OFFSET;
			WIDTH=300;
			HEIGHT=300;
			updataDisplay();
			
			addEventListener(MouseEvent.CLICK,__mouseClick);
			loader.addEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
			loader.addEventListener(MouseEvent.ROLL_OUT,__loaderMouseOut);
			loader.addEventListener(MouseEvent.ROLL_OVER,__loaderMouseOver);
		}
		private function __loaderMouseOut(e:Event):void
		{
			updataMouseCursor();
			MouseManager.cursor = null;
			isMouseOnLoader = false;
		}
		private function __loaderMouseOver(e:Event):void
		{
			isMouseOnLoader = true;
			updataMouseCursor();
		}
		private function __mouseClick(e:MouseEvent):void
		{
			if(MouseManager.cursor == null)
			{
				dispatchEvent(new Event("click_close"));
			}else
			{
				switch(mouseAsset.currentFrame)
				{
					case 1:
						dispatchEvent(new Event("click_right"));
					break;
					case 2:
						dispatchEvent(new Event("click_left"));
					break;
				}
			}
		}
		private function __mouseMove(e:Event):void
		{
			updataMouseCursor();	
		}
		private function updataMouseCursor():void
		{
			if(isMouseOnLoader)
			{
				if(mouseX<this.width/2)
				{
					mouseAsset.gotoAndStop(2);
					MouseManager.cursor = mouseAsset;
				}
				if(mouseX>this.width/2)
				{
					mouseAsset.gotoAndStop(1);
					MouseManager.cursor = mouseAsset;
				}
			}else
			{
				MouseManager.cursor = null;
			}
		}
		protected override function init():void
		{
			super.init();
			addChild(closeBtn);
			closeBtn.buttonMode = true;
			textfield=new TextField;
			addChild(textfield);
			
			var format:TextFormat = textfield.getTextFormat();
			format.size=14;
			format.bold=true;
			format.color=0x6f6f6f;
			format.font="宋体";
			textfield.defaultTextFormat=format;
			textfield.multiline=true;
			textfield.wordWrap=true;
			textfield.filters=[new BlurFilter(0,0,0)]
			textfield.height=BOTTOM-OFFSET;
			textfield.selectable = false;
			textfield.mouseEnabled = false;
			
			TweenLite.from(this,0.5,{alpha:0,overwrite:0});
		}
		private function updateClosePostion():void
		{
			closeBtn.x = back.width - closeBtn.width - OFFSET*2;
			closeBtn.y = OFFSET - 10;
		}
		protected override function updataDisplay():void
		{
			super.updataDisplay();
			updateClosePostion()
			updataTextfieldPos();
			
		}
		private function updataTextfieldPos():void
		{
			textfield.x=OFFSET;
			textfield.y=back.height-BOTTOM;
			textfield.width=back.width-OFFSET*2;
		}
		protected override function __onComplete(e:Event):void
		{
			super.__onComplete(e);
			updateSizeAndPosition();
//			loader.removeEventListener(Event.COMPLETE,__onComplete);
//			loader.addEventListener(Event.COMPLETE,super.__onComplete);
		}
		private function updateSizeAndPosition():void
		{
			loader.visible=false;
			textfield.visible=false;
			textfield.text=data.text;
			var width_final:Number=loader.width+OFFSET*2;
			var height_final:Number=loader.height+OFFSET*2+BOTTOM;
			
			TweenLite.to(this,1,{x:String(-(width_final-back.width)/2),y:String(-(height_final-back.height)/2),overwrite:0});
			TweenLite.to(back,1,{width:width_final,height:height_final,onComplete:function():void
			{
				loader.visible=true;
				textfield.visible=true;
				TweenLite.from(loader,0.5,{alpha:0});
				updataTextfieldPos();
				TweenLite.from(textfield,1,{alpha:0,delay:0.5});
			},onUpdate:function():void
			{
				updateClosePostion();
			},ease:Strong.easeInOut});
		}
		public override function removeFromDisplayList():void
		{
			loader.removeEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
			loader.removeEventListener(MouseEvent.ROLL_OUT,__loaderMouseOut);
			loader.removeEventListener(MouseEvent.ROLL_OVER,__loaderMouseOver);
			removeEventListener(MouseEvent.CLICK,__mouseClick);
//			TipManager.getInstance().removeTipFrom(back);
			MouseManager.cursor = null;
			MyEffect.removeChild(new EffectPv3dRota(parent,this,1,false,1,0,0.5));
		}
		
	}
}
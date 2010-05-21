package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.easing.Strong;
	
	import yzhkof.AddToStageSetter;
	import yzhkof.effect.MyEffect;
	import yzhkof.ui.mouse.MouseManager;

	public class ImageBigViewer extends ImageViewer
	{
		private const OFFSET:Number=10;
		private const BOTTOM:Number=50;
		
		private var textfield:TextField;
		
		private var data:PhotoData;
		
		private static const mouseAsset:MouseAsset = new MouseAsset;
		
		public function ImageBigViewer(data:PhotoData)
		{
			this.data=data;
			
			super(data.url);
			WIDTH=300;
			HEIGHT=300;
			updataDisplay();
			addEventListener(MouseEvent.ROLL_OUT,__mouseOut);
			addEventListener(MouseEvent.CLICK,__mouseClick);
			AddToStageSetter.delayExcuteAfterAddToStage(this,function():void
			{
				addEventListener(Event.ENTER_FRAME,__enterFrame);
			});
		}
		private function __mouseClick(e:MouseEvent):void
		{
			switch(mouseAsset.currentFrame)
			{
				case 1:
					dispatchEvent(new Event("click_right"));
				break;
				case 2:
					dispatchEvent(new Event("click_left"));
				break;
				case 3:
					dispatchEvent(new Event("click_close"));
				break;
			}
		}
		private function __mouseOut(e:MouseEvent):void
		{
			MouseManager.cursor = null;
		}
		private function __enterFrame(e:Event):void
		{
			updataMouseCursor();	
		}
		private function updataMouseCursor():void
		{
			if(this.hitTestPoint(stage.mouseX,stage.mouseY,true))
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
				if(mouseY>loader.height + OFFSET)
				{
					mouseAsset.gotoAndStop(3);
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
			textfield.visible=false;
			textfield.height=BOTTOM-OFFSET;
			textfield.text=data.text;
			textfield.selectable = false;
			
			TweenLite.from(this,0.5,{alpha:0,overwrite:0});
		}
		protected override function updataDisplay():void
		{
			super.updataDisplay();
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
			loader.x=OFFSET;
			loader.y=OFFSET;
			loader.visible=false;
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
			},ease:Strong.easeInOut});
		}
		public override function removeFromDisplayList():void
		{
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			removeEventListener(MouseEvent.ROLL_OUT,__mouseOut);
			removeEventListener(MouseEvent.CLICK,__mouseClick);
			MouseManager.cursor = null;
			MyEffect.removeChild(new EffectPv3dRota(parent,this,1,false,1,0,0.5));
		}
		
	}
}
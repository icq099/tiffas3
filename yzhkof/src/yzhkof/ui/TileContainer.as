package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import yzhkof.display.RenderSprite;

	public class TileContainer extends RenderSprite
	{
		private var widthSize:Number=400;
		private var heightSize:Number=300;
		private var paddingH:Number=10;
		private var paddingV:Number=10;
		
		private var isChange:Boolean = false;
		
		public function TileContainer()
		{
			super();
		}
		public override function addChild(child:DisplayObject):DisplayObject
		{
			isChange=true;
			return super.addChild(child)
		}
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			isChange=true;
			return super.removeChild(child);
		}
		public override function set width(value:Number):void
		{
			widthSize=value;
			isChange=true;
		}
		public override function get width():Number
		{
			return widthSize;
		}
		public override function set height(value:Number):void
		{
			heightSize=value;
			isChange=true;
		}
		public override function get height():Number
		{
			return heightSize;
		}
		public function removeAllChildren():void
		{
			var i:int;
			var length:int=numChildren;
			for (i=0;i<length;i++)
			{
				removeChildAt(0);
			}
		}
		protected override function onRend():void
		{
			if(isChange)
			{
				updataChildPosition();
				isChange=false;
			}
		}
		public function updataChildPosition():void
		{
			var position:Point=new Point();
			var i:int;
			var current_dobj:DisplayObject;
			for (i=0;i<numChildren;i++)
			{
				var t_obj:DisplayObject=getChildAt(i);
				if(t_obj.getBounds(this).y>heightSize)
				{
					t_obj.visible=false;
					continue;
				}
				current_dobj=t_obj;
				current_dobj.x=position.x;
				current_dobj.y=position.y;
				
				position.x+=current_dobj.width+paddingH;
				if((i+1)<numChildren)
				{
					if((getChildAt(i+1).width+paddingH+position.x)>widthSize)
					{
						position.y+=current_dobj.height+paddingV;
						position.x=0;
					}
				}
			}
		}
		
	}
}
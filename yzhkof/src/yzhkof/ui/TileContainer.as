package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import yzhkof.display.RenderSprite;

	public class TileContainer extends RenderSprite
	{
		private var widthSize:Number=400;
		private var heightSize:Number=300;
		private var paddingH:Number=10;
		private var paddingV:Number=10;
		private var _columnCount:uint=int.MAX_VALUE;//列数
		private var _rowCount:uint=int.MAX_VALUE;//行数
		
		private var isChange:Boolean = false;
		
		public function TileContainer()
		{
			super();
			init();
		}
		private function init():void
		{
			addEventListener(Event.ADDED,__childAdd);
			addEventListener(Event.REMOVED,__childRemove);
		}
		private function __childAdd(e:Event):void
		{
			isChange=true;
		}
		private function __childRemove(e:Event):void
		{
			isChange=true;
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
			}
		}
		public function updataChildPosition():void
		{
			isChange=false;
			var position:Point=new Point();
			var i:int;
			var current_dobj:DisplayObject;
			var t_column:uint=0;
			var t_row:uint=0;
			for (i=0;i<numChildren;i++)
			{
				var t_obj:DisplayObject=getChildAt(i);
				t_obj.visible=true;
				if((t_obj.getBounds(this).y>heightSize)||(t_row>rowCount))
				{
					t_obj.visible=false;
					continue;
				}
				current_dobj=t_obj;
				current_dobj.x=position.x;
				current_dobj.y=position.y;
				//下个child的位置
				position.x+=current_dobj.width+paddingH;
				if((i+1)<numChildren)
				{
					if(((getChildAt(i+1).width+paddingH+position.x)>widthSize)||(t_column>=_columnCount))
					{
						position.y+=current_dobj.height+paddingV;
						position.x=0;
						t_column=0;
						t_row++;
					}else
					{
						t_column++;
					}
				}
			}
		}

		public function get columnCount():uint
		{
			return _columnCount;
		}

		public function set columnCount(value:uint):void
		{
			_columnCount = value;
			isChange=true;
		}

		public function get rowCount():uint
		{
			return _rowCount;
		}

		public function set rowCount(value:uint):void
		{
			_rowCount = value;
			isChange=true;
		}

		
	}
}
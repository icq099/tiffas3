package yzhkof.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import yzhkof.display.RenderSprite;

	public class TileContainer extends RenderSprite
	{
		private var widthSize:Number=400;
		private var heightSize:Number=300;
		private var _paddingH:Number=10;
		private var _paddingV:Number=10;
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
		/**
		 * 手动更新布局 
		 * 
		 */
		public function updataChildPosition():void
		{
			isChange=false;
			var position:Point=new Point();
			var i:int;
			var current_dobj:DisplayObject;
			var t_column:uint=0;
			var t_row:uint=0;
			var t_obj:DisplayObject
			var layout:Object;
			
			for (i=0;i<numChildren;i++)
			{
				t_obj=getChildAt(i);
				layout=getItemLayout(t_obj);
				
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
				position.x+=layout.width+layout.paddingH;
				if((i+1)<numChildren)
				{
					if(((getItemLayout(getChildAt(i+1)).width+layout.paddingH+position.x)>widthSize)||(t_column>=_columnCount))
					{
						position.y+=layout.height+layout.paddingV;
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
		public function get contentWidth():Number
		{
			return super.width;	
		}
		public function get contentHeight():Number
		{
			return super.height
		}
		public override function addChild(child:DisplayObject):DisplayObject
		{
			throw new Error("use appendItem method!");
		}
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			throw new Error("use removeItem method!");
		}
		public function removeItem(child:DisplayObject):void
		{
			super.removeChild(child);
			delete layoutMap[child];
			isChange=true;
		}
		private var layoutMap:Dictionary=new Dictionary(true);
		/**
		 * 添加Item（实现方式为直接addChild，显示外的visible为false） 
		 * @param child
		 * @param itemLayout {width:(自定义当前child的width大小，默认为child.width),height:(与width相同,但多行多列时一般不对此属性赋值),paddingH:(此child与下一个child之前的水平空隙，默认为空中的paddingH的值),paddingV:(同paddingH，但多行多列时一般不对此属性赋值)}
		 * 
		 */	
		public function appendItem(child:DisplayObject,itemLayout:Object=null):void
		{
			if(itemLayout)
				layoutMap[child]=itemLayout;
			else
				layoutMap[child]=new Object;
			super.addChild(child);
			
			isChange=true;
		}
		private function getItemLayout(child:DisplayObject):Object
		{
			var re_lo:Object=new Object;
			var lo:Object=layoutMap[child];
			var bound_child:Rectangle=child.getBounds(this);

			re_lo.width=lo.width||bound_child.width;
			re_lo.height=lo.height||bound_child.height;
			re_lo.paddingV=lo.paddingV||paddingV;
			re_lo.paddingH=lo.paddingH||paddingH;
			return re_lo;
		}

		public function get paddingH():Number
		{
			return _paddingH;
		}

		public function set paddingH(value:Number):void
		{
			_paddingH = value;
		}

		public function get paddingV():Number
		{
			return _paddingV;
		}

		public function set paddingV(value:Number):void
		{
			_paddingV = value;
		}

		
	}
}
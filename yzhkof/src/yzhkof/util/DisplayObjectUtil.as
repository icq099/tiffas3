package yzhkof.util
{
	import flash.display.DisplayObject;

	public class DisplayObjectUtil
	{
		public static function setSizeFit(dobj:DisplayObject,containerWidth:Number,containerHeight:Number):void
		{
			if(dobj.width>containerWidth&&dobj.height>containerHeight)
			{
				var horizontal:Boolean=dobj.width/containerWidth>dobj.height/containerHeight?true:false;
				if(horizontal)
				{
					dobj.height=containerHeight;
					dobj.scaleX=dobj.scaleY;
				}else
				{
					dobj.width=containerWidth;
					dobj.scaleY=dobj.scaleX;
				}
			}
		}
	}
}
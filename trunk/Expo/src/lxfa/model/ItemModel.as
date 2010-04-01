package lxfa.model
{
	//定制窗数据的model
	//先根据索引找到起点和终点
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import lxfa.utils.MemoryRecovery;
	
	public class ItemModel extends EventDispatcher
	{
		private const path:String="xml/item.xml";//XML文件的路径了
		public var xmlData:XML;                  //XML数据
		private var offsetName:String;           //索引的名字
		private var min:int;                     //最小值
		private var max:int;                     //最大值
		public function ItemModel(name:String)
		{
			xmlData=ModelManager.getInstance().xmlData();
			this.dispatchEvent(new Event(Event.COMPLETE));
			setOffsetName(name);//存储索引的路径
		}
		//存储索引名字
		private function setOffsetName(name:String):void
		{
			this.offsetName=name;
		}
		//获取最小值
		public function getMin():int
		{
			return min;
		}
		//获取最大值
		public function getMax():int
		{
			return max;
		}
		//获取XML数据
		public function getXmlData():XML
		{
			return xmlData;
		}
		//获取定制窗的图片路径
		public function getImgUrl(num:int):String
		{
			if(xmlData.Item[num+min]!=null)
			{
				return xmlData.Item[num+min].@image;
			}
			return null;
		}
		//获取指定位置的标准窗的图片路径
		public function getPicture360Url(num:int):String
		{
			return xmlData.Item[num+min].Picture360[0];
		}
		//获取360图片的名字
		public function getPicture360Name(num:int):String
		{
			if(xmlData.Item[num+min].Picture360[0]!=null)
			{
				return xmlData.Item[num+min].Picture360[0].@name;
			}
			return null;
		}
		//定制窗里面，图片的数目
		public function getItemOfNumber():int
		{
			return max-min;//Item的长度
		}
		//标准窗视频的路径
		public function getVideoUrl(num:int):String
		{
			return xmlData.Item[num+min].Video[0];
		}
		//视频的名字
		public function getVideoName(num:int):String
		{
			if(xmlData.Item[num+min].Video[0]!=null)
			{
				return xmlData.Item[num+min].Video[0].@name;
			}
			return null;
		}
		//桂娃的ID
		public function getAnimateId(ID:int):int{
			var temp:String=xmlData.Item[ID+min].Animate[0];
			if(temp==null || temp=="")
			{
				return -1;
			}
			return int(temp);
		}
		//获取标准窗的文本
		public function getText(num:int):String
		{
			return xmlData.Item[num+min].Text[0];
		}
		//获取图片的路径
		public function getPictureUrls(num:int):Array
		{
			var i:int;
			var pictureUrls:Array=new Array();
			for(i=0;i<xmlData.Item[num+min].Picture.length();i++)
			{
				pictureUrls.push(xmlData.Item[num+min].Picture[i]);
			}
			return pictureUrls;
		}
		//获取swf的路径
		public function getSwfUrl(num:int):String
		{
			return xmlData.Item[num+min].Swf[0];
		}
		//类型
		public function getType(num:int):String
		{
			if(xmlData.Item[num+min]!=null)
			{
				return xmlData.Item[num+min].@type;
			}
			return null;
		}
		public function getPictureName(num:int):String
		{
			if(xmlData.Item[num+min].Picture[0]!=null)
			{
				return xmlData.Item[num+min].Picture[0].@name;
			}
			return null;
	    }
	    public function dispose():void
	    {
	    	MemoryRecovery.getInstance().gcObj(xmlData);
	    }
	}
}
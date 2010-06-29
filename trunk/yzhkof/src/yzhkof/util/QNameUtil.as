package yzhkof.util
{
	import flash.sampler.getMemberNames;
	
	import yzhkof.debug.traceObject;
	
	public class QNameUtil
	{
		public static const LISTENERS:QName=new QName("flash.events:EventDispatcher","listeners");
		public static const SAVEDTHIS:QName=new QName("builtin.as$0:MethodClosure","savedThis");
		public static function isListeners(qName:QName):Boolean
		{
			return isEqual(qName,LISTENERS);
		}
		public static function isSavedThis(qName:QName):Boolean
		{
			return isEqual(qName,SAVEDTHIS);
		}
		public static function isEqual(qName1:QName,qName2:QName):Boolean
		{
			if(qName1.uri==qName2.uri&&qName1.localName==qName2.localName)
			{
				return true;
			}
			return false;
		}
		public static function getObjectQname(obj:Object,qName:QName):QName
		{
			var qNames:Object=getMemberNames(obj);
			for each(var i:QName in qNames)
			{
				if(isEqual(i,qName))
				{
					return i;
				}	
			}
			return null;
		}
	}
}
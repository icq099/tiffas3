package format.swf.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import format.swf.Instance_info;
	import format.swf.Multiname_info;
	import format.swf.Namespace_info;
	import format.swf.SwfFile;
	import format.swf.tag.DoABC;
	import format.swf.tag.SymbolClass;
	import format.swf.tag.TagOfSwf;
	
	public class SwfFileCode extends SwfFile
	{

		private var _documentDoabc:DoABC;
		private var _documentDoabcTag:int;
		private var _documentName:String;

		private var _documentInstance:Instance_info;
		
		public function SwfFileCode(byte:ByteArray)
		{
			super(byte);
			doFile();
		}
		
		private function doFile():void
		{
			var symbolClass_arr:Array = tagReader.getTagReaderByType(TagOfSwf.SymbolClass);
			if(symbolClass_arr == null) return;
			
			for each (var m:SymbolClass in symbolClass_arr) 
			{
				var name_map:Dictionary;
				name_map = m.tagToNameMap;
				for (var o:String in name_map)
				{
					if(uint(o) == 0)
					{
						_documentName = name_map[o];
					}
				}
			}
			
			_documentDoabcTag = 82;
			
			var doabc_arr:Array;
			doabc_arr = tagReader.getTagReaderByType(TagOfSwf.DOABC);
			if((doabc_arr == null)||(doabc_arr.length <=0))
			{
				doabc_arr = tagReader.getTagReaderByType(TagOfSwf.DOABC72);
				_documentDoabcTag = 72;
			}
			
			if((doabc_arr == null)||(doabc_arr.length <=0)) return;
			
			for each (var i:DoABC in doabc_arr) 
			{
				if(i.name == documentName)
				{
					_documentDoabc = i;
					break;
				}
			}
			
			_documentDoabc = _documentDoabc||doabc_arr[0];
			
			var multiNameArr:Array = documentDoabc.abcfile.constant_pool.multiname;
			var namespaceArr:Array = documentDoabc.abcfile.constant_pool.namespace_abc;
			var instanceArr:Array = documentDoabc.abcfile.instance;
			var stringsArr:Array = documentDoabc.abcfile.constant_pool.string;
			
			var documentMultiNameInfoIndex:uint;
			
			for (var j:int = 0; j < multiNameArr.length; j++) 
			{
				var mnInfo:Multiname_info = Multiname_info(multiNameArr[j]);
				var nsInfo:Namespace_info = Namespace_info(namespaceArr[mnInfo.ns]);
				var qname:String = stringsArr[nsInfo.name].utf8str + stringsArr[mnInfo.name].utf8str;
				if(qname == documentName)
				{
					documentMultiNameInfoIndex = j;
					break;
				}
			}
			
			var documentIIIndex:uint;
			for (var k:int = 0; k < instanceArr.length; k++) 
			{
				if(Instance_info(instanceArr[k]).name == documentMultiNameInfoIndex)
				{
					documentIIIndex = k;
					break;
				}
			}
			
			_documentInstance = Instance_info(instanceArr[documentIIIndex]);
		}

		public function get documentDoabc():DoABC
		{
			return _documentDoabc;
		}

		public function get documentDoabcTag():int
		{
			return _documentDoabcTag;
		}

		public function get documentName():String
		{
			return _documentName;
		}

		public function get documentInstance():Instance_info
		{
			return _documentInstance;
		}
		
	}
}